# frozen-string-literal: true

require_relative "header_builder"

module Bioshogi
  module Formatter
    concern :ExportMethods do
      MIN_TURN = 14

      include HeaderBuilder

      def mediator_run_once
        mediator
      end

      def mediator_class
        @parser_options[:mediator_class] || Mediator
      end

      def mediator_new
        mediator_class.new.tap do |e|
          e.params.update(@parser_options.slice(*[
                :skill_monitor_enable,
                :skill_monitor_technique_enable,
                :candidate_enable,
                :validate_enable,
                :validate_double_pawn_skip,
                :validate_warp_skip,
              ]))
        end
      end

      # 画像生成のための mediator の初期状態を返す
      def mediator_for_image
        mediator = Mediator.new
        mediator.params.update({
            :skill_monitor_enable           => false,
            :skill_monitor_technique_enable => false,
            :candidate_enable               => false,
            :validate_enable                => false,
          })
        mediator_board_setup(mediator) # FIXME: これ、必要ない SFEN を生成したりして遅い
        mediator
      end

      def mediator
        @mediator ||= mediator_new.tap do |e|
          mediator_board_setup(e)
          mediator_run_all(e)
        end
      end

      # FIXME: mediator の最初の状態をコピーしておく
      def initial_mediator
        @initial_mediator ||= mediator_new.tap do |e|
          mediator_board_setup(e)
        end
      end

      def mediator_board_setup(mediator)
        case1(mediator)
        mediator.before_run_process # 最初の状態を記録
      end

      def case1(mediator)
        players_piece_box_set(mediator)

        if @board_source
          mediator.board.placement_from_shape(@board_source)
        else
          preset_info = PresetInfo[header["手合割"]] || PresetInfo["平手"]
          mediator.placement_from_preset(preset_info.key)
        end

        if force_location
          mediator.turn_info.turn_base = force_location.code
        end

        if force_handicap
          mediator.turn_info.handicap = force_handicap
        end
      end

      # 持駒を反映する
      def players_piece_box_set(mediator)
        player_piece_boxes.each do |k, v|
          mediator.player_at(k).piece_box.set(v)
        end
      end

      # 盤面の指定があるとき、盤面だけを見て、手合割を得る
      def board_preset_info
        @board_preset_info ||= yield_self do
          if @board_source
            Board.guess_preset_info(@board_source)
          end
        end
      end

      # 手合割
      def preset_info
        @preset_info ||= @force_preset_info
        @preset_info ||= initial_mediator.board.preset_info
        @preset_info ||= PresetInfo[header["手合割"]]
        @preset_info ||= PresetInfo["平手"]
      end

      # 消す
      # names_set(black: "alice", white: "bob")
      def names_set(params)
        locations = Location.send(handicap? ? :reverse_each : :itself)
        locations.each do |e|
          header[e.call_name(handicap?)] = params[e.key] || "？"
        end
      end

      def mediator_run_all(mediator)
        # FIXME: ここらへんは mediator のなかで実行する
        begin
          move_infos.each.with_index do |info, i|
            if @parser_options[:debug]
              p mediator
            end
            if @parser_options[:callback]
              @parser_options[:callback].call(mediator)
            end
            if @parser_options[:turn_limit] && mediator.turn_info.display_turn >= @parser_options[:turn_limit]
              break
            end
            mediator.execute(info[:input], used_seconds: used_seconds_at(i))
          end
        rescue CommonError => error
          if v = @parser_options[:typical_error_case]
            case v
            when :embed
              @error_message = error.message
            when :skip
            else
              raise MustNotHappen
            end
          else
            raise error
          end
        end

        if @parser_options[:skill_monitor_enable]

          # 力戦判定(適当)
          if ENV["BIOSHOGI_ENV"] != "test"
            if mediator.turn_info.display_turn >= MIN_TURN
              # if mediator.players.all? { |e| e.skill_set.power_battle? }
              #   mediator.players.each do |e|
              #     e.skill_set.push(AttackInfo["乱戦"])
              #   end
              # else
              mediator.players.each do |e|
                e.skill_set.rikisen_check_process
              end
              # end
            end
          end

          # 両方が入玉していれば「相入玉」タグを追加する
          # この場合、両方同時に入玉しているかどうかは判定できない
          if NoteInfo.values.present?
            if mediator.players.all? { |e| e.skill_set.has_skill?(NoteInfo["入玉"]) }
              mediator.players.each do |player|
                player.skill_set.list_push(NoteInfo["相入玉"])
              end
            end

            if ENV["BIOSHOGI_ENV"] != "test"
              # 1. 最初に設定
              # とりあえず2つに分けたいので「振り飛車」でなければ「居飛車」としておく
              if preset_info
                if preset_info.special_piece
                  mediator.players.each do |player|
                    if !player.skill_set.has_skill?(NoteInfo["振り飛車"]) && !player.skill_set.has_skill?(NoteInfo["居飛車"])
                      player.skill_set.list_push(NoteInfo["居飛車"])
                    end
                  end

                  if true
                    # 両方居飛車なら相居飛車
                    if mediator.players.all? { |e| e.skill_set.has_skill?(NoteInfo["居飛車"]) }
                      mediator.players.each do |player|
                        player.skill_set.list_push(NoteInfo["相居飛車"])
                      end
                    end

                    # 両方振り飛車なら相振り
                    if mediator.players.all? { |e| e.skill_set.has_skill?(NoteInfo["振り飛車"]) }
                      mediator.players.each do |player|
                        player.skill_set.list_push(NoteInfo["相振り"])
                      end
                    end

                    # 片方だけが「振り飛車」なら、振り飛車ではない方に「対振り」。両方に「対抗型」
                    if player = mediator.players.find { |e| e.skill_set.has_skill?(NoteInfo["振り飛車"]) }
                      others = mediator.players - [player]
                      if others.none? { |e| e.skill_set.has_skill?(NoteInfo["振り飛車"]) }
                        others.each { |e| e.skill_set.list_push(NoteInfo["対振り"]) }
                        mediator.players.each { |e| e.skill_set.list_push(NoteInfo["対抗型"]) }
                      end
                    end
                  end

                  # 大駒がない状態で勝ったら「背水の陣」
                  mediator.players.each do |player|
                    if player == mediator.win_player
                      if player.stronger_piece_have_count.zero?
                        player.skill_set.list_push(NoteInfo["背水の陣"])
                      end
                    end
                  end
                end

                # if mediator.players.any? { |e| e.skill_set.note_infos.include?(NoteInfo["振り飛車"]) }
                #   mediator.players.each do |player|
                #     player.skill_set.list_push(NoteInfo["相振り飛車"])
                #   end
                # end

                # 居玉判定
                if true
                  # if preset_info.key == :"平手"
                  mediator.players.each do |e|
                    # 14手以上の対局で一度も動かずに終了した
                    done = false
                    if !done
                      if mediator.turn_info.display_turn >= MIN_TURN && e.king_moved_counter.zero?
                        done = true
                      end
                    end
                    if !done
                      if mediator.outbreak_turn # 歩と角以外の交換があったか？
                        v = e.king_first_moved_turn
                        if v.nil? || v >= mediator.outbreak_turn  # 玉は動いていない、または戦いが激しくなってから動いた
                          done = true
                        end
                      end
                    end
                    if done
                      e.skill_set.list_push(DefenseInfo["居玉"])
                    end
                  end
                  # 両方居玉だったら備考に相居玉
                  if mediator.players.all? { |e| e.skill_set.has_skill?(DefenseInfo["居玉"]) }
                    mediator.players.each do |e|
                      e.skill_set.list_push(NoteInfo["相居玉"])
                    end
                  end
                  # end
                end
              end
            end
          end

          begin
            # ヘッダーに埋める
            TacticInfo.each do |e|
              mediator.players.each do |player|
                list = player.skill_set.public_send(e.list_key).normalize
                if v = list.presence
                  v = v.uniq # 手筋の場合、複数になる場合があるので uniq する
                  skill_set_hash["#{player.call_name}の#{e.name}"] = v.collect(&:name)
                end
              end
            end
            hv = skill_set_hash.transform_values { |e| e.join(", ") }
            header.object.update(hv)
          end
        end
      end

      def skill_set_hash
        @skill_set_hash ||= {}
      end

      def judgment_message
        mediator_run_once

        # 将棋倶楽部24の棋譜だけに存在する、自分の手番で相手が投了したときの文言に対応する
        if true
          if @last_action_params
            v = @last_action_params[:last_action_key]
            unless LastActionInfo[v]
              if v == "反則勝ち"
                v = "#{mediator.current_player.call_name}の手番なのに#{mediator.opponent_player.call_name}が投了 (将棋倶楽部24だけに存在する「反則勝ち」)"
              end
              # "*" のあとにスペースを入れると、激指でコメントの先頭にスペースが入ってしまうため、仕方なくくっつけている
              return "*#{v}"
            end
          end
        end

        last_action_info.judgment_message(mediator)
      end

      def raw_header_part_hash
        header.object.collect { |key, value|
          if value
            if e = CsaHeaderInfo[key]
              if e.as_kif
                value = e.instance_exec(value, &e.as_kif)
              end
            end
            [key, value]
          end
        }.compact.to_h
      end

      def last_action_info
        key = nil

        # エラーなら最優先
        unless key
          if @error_message
            key = :ILLEGAL_MOVE
          end
        end

        # 元の棋譜の記載を優先
        unless key
          if @last_action_params
            v = @last_action_params[:last_action_key]
            if LastActionInfo[v]
              key = v
            end
          end
        end

        LastActionInfo.fetch(key || :TORYO)
      end

      def used_seconds_at(index)
        @move_infos.dig(index, :used_seconds).to_i
      end

      def clock_exist?
        return @clock_exist if instance_variable_defined?(:@clock_exist)
        @clock_exist = @move_infos.any? { |e| e[:used_seconds].to_i.nonzero? }
      end

      def clock_nothing?
        !clock_exist?
      end

      def error_message_part(comment_mark = "*")
        if @error_message
          v = @error_message.strip + "\n"
          s = "-" * 76 + "\n"
          [s, *v.lines, s].collect {|e| "#{comment_mark} #{e}" }.join
        end
      end

      ################################################################################

      def to_kif(options = {})
        KifBuilder.new(self, options).to_s
      end

      def to_ki2(options = {})
        Ki2Builder.new(self, options).to_s
      end

      def to_csa(options = {})
        CsaBuilder.new(self, options).to_s
      end

      def to_sfen(options = {})
        SfenBuilder.new(self, options).to_s
      end

      def to_bod(options = {})
        BodBuilder.new(self, options).to_s
      end

      def to_yomiage(options = {})
        YomiageBuilder.new(self, options).to_s
      end

      def to_yomiage_list(options = {})
        YomiageBuilder.new(self, options).to_a
      end

      def to_akf(options = {})
        AkfBuilder.new(self, options).to_h
      end

      ################################################################################

      def image_renderer(options = {})
        ImageRenderer.new(mediator, options)
      end

      def to_image(options = {})
        image_renderer(options).to_blob_binary
      end

      ################################################################################

      def to_png(options = {})
        ImageRenderer.new(mediator, options.merge(image_format: "png")).to_blob_binary
      end

      def to_jpg(options = {})
        ImageRenderer.new(mediator, options.merge(image_format: "jpg")).to_blob_binary
      end

      def to_gif(options = {})
        ImageRenderer.new(mediator, options.merge(image_format: "gif")).to_blob_binary
      end

      def to_webp(options = {})
        ImageRenderer.new(mediator, options.merge(image_format: "webp")).to_blob_binary
      end

      ################################################################################

      def to_animation_mp4(options = {})
        AnimationMp4Builder.new(self, options).to_binary
      end

      def to_animation_gif(options = {})
        AnimationGifBuilder.new(self, options).to_binary
      end

      def to_animation_apng(options = {})
        AnimationPngBuilder.new(self, options).to_binary
      end

      def to_animation_webp(options = {})
        AnimationWebpBuilder.new(self, options).to_binary
      end

      def to_animation_zip(options = {})
        AnimationZipBuilder.new(self, options).to_binary
      end
    end
  end
end
