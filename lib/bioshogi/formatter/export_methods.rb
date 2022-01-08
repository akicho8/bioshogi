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

      def initial_mediator
        @initial_mediator ||= mediator_new.tap do |e|
          mediator_board_setup(e)
        end
      end

      def mediator_board_setup(mediator)
        @break = nil
        [
          :case1,
        ].each do |m|
          send(m, mediator)
          if @break
            break
          end
        end
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

        turn_base_set_p = false

        # p ["#{__FILE__}:#{__LINE__}", __method__, turn_base_set_p]
        if force_location
          # if @board_source
          mediator.turn_info.turn_base = force_location.code
          # turn_base_set_p = true
          # end
        end

        if force_handicap
          mediator.turn_info.handicap = force_handicap
        end

        # unless turn_base_set_p
        #   if !handicap_p
        #     if v = header.force_location
        #       if v.key == :white
        #         mediator.turn_info.turn_base = 1
        #         turn_base_set_p = true
        #       end
        #     end
        #   end
        # end

        # handicap_p =

        # unless turn_base_set_p
        #   turn_base_set_p = false
        # end

        # if v = header["手合割"]
        #   if preset_info = PresetInfo[v]
        #     mediator.turn_info.handicap = preset_info.handicap
        #   end
        # end

        # unless turn_base_set_p
        #   if handicap?
        #     mediator.turn_info.handicap = true
        #     mediator.turn_info.turn_base = 1
        #     turn_base_set_p = true
        #   end
        # end

        # unless turn_base_set_p
        #   unless header.force_location
        #     v = header.handicap_validity2
        #     if !v.nil?
        #       mediator.turn_info.handicap = v
        #       turn_base_set_p = true
        #     end
        #   end
        # end

        # 「後手番」または「上手番」だけ書いた行がある場合
        # ただしすでに駒落ちの場合は無視する(そうしないと反転の反転で▲から始まってしまう)
        # unless turn_base_set_p
        #   if !handicap_p
        #     if v = header.force_location
        #       if v.key == :white
        #         mediator.turn_info.turn_base = 1
        #         turn_base_set_p = true
        #       end
        #     end
        #   end
        # end

        # KIFに手数の表記があって2手目から始まっているなら2手目までカウンタを進める
        # KIFはかならず1から始まるルールらしいのでこれは間違った解釈
        #
        # 手数----指手---------消費時間--
        #   3 76歩
        #
        # であれば 2 を設定
        # unless turn_base_set_p
        #   if e = move_infos.first
        #     if v = e[:turn_number]
        #       mediator.turn_info.turn_base = v.to_i.pred
        #       turn_base_set_p = true
        #     end
        #   end
        # end

        # こちらも間違った解釈
        # 手数が2以上から始まるKIFはないけど一応対応しとこう
        # unless turn_base_set_p
        #   #
        #   # 先手の備考：居飛車, 相居飛車, 居玉, 相居玉
        #   # 後手の備考：居飛車, 相居飛車, 居玉, 相居玉
        #   # 後手の持駒：銀 歩三
        #   #   ９ ８ ７ ６ ５ ４ ３ ２ １
        #   # +---------------------------+
        #   # |v香v飛 ・ ・ ・ ・v玉v桂v香|一
        #   # | ・ ・ ・v金 ・ ・v金v銀 ・|二
        #   # | ・ ・ ・ ・v歩v歩 歩 ・ ・|三
        #   # |v歩 ・ ・ ・ ・v角 桂v歩v歩|四
        #   # | ・ ・v歩 銀v銀 桂 ・ ・ ・|五
        #   # | 歩 歩 歩 歩 ・ 歩 ・ ・ 歩|六
        #   # | ・ ・ 桂 ・ 歩 ・ 金 ・ ・|七
        #   # | ・ ・ 金 ・ ・ ・ ・ ・ ・|八
        #   # | 香 ・ 玉 ・ ・ ・ ・ 飛 香|九
        #   # +---------------------------+
        #   # 先手の持駒：角 歩
        #   # 手数----指手---------消費時間--
        #   #   72 投了
        #   # まで71手で先手の勝ち
        #   #
        #   # 72 で投了ということは 71 まで進める
        #   #
        #   if move_infos.empty?
        #     if @last_status_params
        #       if v = @last_status_params[:turn_number]
        #         mediator.turn_info.turn_base = v.to_i.pred
        #         turn_base_set_p = true
        #       end
        #     end
        #   end
        # end

        # 「駒落ち判定」と「手番判定」が重複すると反対の反対で駒落ちなのに▲から始まってしまう
        # それを防ぐために「手番判定」がなかったときのみ handicap 指定とする
        # unless turn_base_set_p
        #   mediator.turn_info.handicap = handicap?
        # end

        # さらに
        # "まで71手で先手の勝ち"
        # の部分を見てカウンタをセットすることもできるけど
        # まだ必要になってないのでやらない
        #
        # 71手目からはじまるKIFはないのでこれも間違った解釈
        @break
      end

      # 持駒を反映する
      def players_piece_box_set(mediator)
        # Location.each do |e|
        #   e.call_names.each do |e|
        #     if v = header["#{e}の持駒"]
        #       mediator.player_at(e).piece_box.set(Piece.s_to_h(v))
        #     end
        #   end
        # end
        player_piece_boxes.each do |k, v|
          mediator.player_at(k).piece_box.set(v)
        end
      end

      def handicap?
        v = header.handicap_validity
        if !v.nil?
          return v
        end

        if e = board_preset_info
          return e.handicap
        end

        false
      end

      # 盤面の指定があるとき、盤面だけを見て、手合割を得る
      def board_preset_info
        @board_preset_info ||= -> {
          if @board_source
            # mediator = Mediator.new
            # mediator.board.placement_from_shape(@board_source)
            # mediator.board.preset_info

            board = Board.new
            board.placement_from_shape(@board_source)
            board.preset_info

          end
        }.call
      end

      # 手合割
      def preset_info
        @preset_info ||= initial_mediator.board.preset_info || board_preset_info || PresetInfo[header["手合割"]] || PresetInfo["平手"]
      end

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

          # ヘッダーに埋める
          TacticInfo.each do |e|
            mediator.players.each do |player|
              if v = player.skill_set.public_send(e.list_key).normalize.uniq.collect(&:name).presence # 手筋の場合、複数になる場合があるので uniq している
                skill_set_hash["#{player.call_name}の#{e.name}"] = v
              end
            end
          end
          header.object.update(skill_set_hash.transform_values { |e| e.join(", ") })
        end
      end

      def skill_set_hash
        @skill_set_hash ||= {}
      end

      def judgment_message
        mediator_run_once

        # 将棋倶楽部24の棋譜だけに存在する、自分の手番で相手が投了したときの文言に対応する
        if true
          if @last_status_params
            v = @last_status_params[:last_action_key]
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
          if @last_status_params
            v = @last_status_params[:last_action_key]
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
