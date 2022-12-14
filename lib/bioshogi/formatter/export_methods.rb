# frozen-string-literal: true

module Bioshogi
  module Formatter
    concern :ExportMethods do
      MIN_TURN = 14

      include HeaderBuilder

      def xcontainer_run_once
        xcontainer
      end

      def xcontainer_class
        @parser_options[:xcontainer_class] || Xcontainer
      end

      def xcontainer_new
        xcontainer_class.new.tap do |e|
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

      # 画像生成のための xcontainer の初期状態を返す
      def xcontainer_for_image
        xcontainer = Xcontainer.new
        xcontainer.params.update({
            :skill_monitor_enable           => false,
            :skill_monitor_technique_enable => false,
            :candidate_enable               => false,
            :validate_enable                => false,
          })
        xcontainer_board_setup(xcontainer) # FIXME: これ、必要ない SFEN を生成したりして遅い
        xcontainer
      end

      def xcontainer
        @xcontainer ||= xcontainer_new.tap do |e|
          xcontainer_board_setup(e)
          xcontainer_run_all(e)
        end
      end

      # FIXME: xcontainer の最初の状態をコピーしておく
      def initial_xcontainer
        @initial_xcontainer ||= xcontainer_new.tap do |e|
          xcontainer_board_setup(e)
        end
      end

      def xcontainer_board_setup(xcontainer)
        case1(xcontainer)
        xcontainer.before_run_process # 最初の状態を記録
      end

      def case1(xcontainer)
        players_piece_box_set(xcontainer)

        if @board_source
          xcontainer.board.placement_from_shape(@board_source)
        else
          preset_info = PresetInfo[header["手合割"]] || PresetInfo["平手"]
          xcontainer.placement_from_preset(preset_info.key)
        end

        if force_location
          xcontainer.turn_info.turn_base = force_location.code
        end

        if force_handicap
          xcontainer.turn_info.handicap = force_handicap
        end
      end

      # 持駒を反映する
      def players_piece_box_set(xcontainer)
        player_piece_boxes.each do |k, v|
          xcontainer.player_at(k).piece_box.set(v)
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
        @preset_info ||= initial_xcontainer.board.preset_info
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

      def xcontainer_run_all(xcontainer)
        # FIXME: ここらへんは xcontainer のなかで実行する
        begin
          move_infos.each.with_index do |info, i|
            if @parser_options[:debug]
              p xcontainer
            end
            if @parser_options[:callback]
              @parser_options[:callback].call(xcontainer)
            end
            if @parser_options[:turn_limit] && xcontainer.turn_info.display_turn >= @parser_options[:turn_limit]
              break
            end
            xcontainer.execute(info[:input], used_seconds: used_seconds_at(i))
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
          rikisen_hantei(xcontainer)

          # 両方が入玉していれば「相入玉」タグを追加する
          # この場合、両方同時に入玉しているかどうかは判定できない
          if Explain::NoteInfo.values.present?
            ainyugyoku_check(xcontainer)

            if true
              # 1. 最初に設定
              # とりあえず2つに分けたいので「振り飛車」でなければ「居飛車」としておく
              if preset_info
                if preset_info.special_piece
                  furibisya_denakereba_ibisha(xcontainer)

                  if true
                    # 両方居飛車なら相居飛車
                    if xcontainer.players.all? { |e| e.skill_set.has_skill?(Explain::NoteInfo["居飛車"]) }
                      xcontainer.players.each do |player|
                        player.skill_set.list_push(Explain::NoteInfo["相居飛車"])
                      end
                    end

                    # 両方振り飛車なら相振り
                    if xcontainer.players.all? { |e| e.skill_set.has_skill?(Explain::NoteInfo["振り飛車"]) }
                      xcontainer.players.each do |player|
                        player.skill_set.list_push(Explain::NoteInfo["相振り"])
                      end
                    end

                    # 片方だけが「振り飛車」なら、振り飛車ではない方に「対振り」。両方に「対抗型」
                    if player = xcontainer.players.find { |e| e.skill_set.has_skill?(Explain::NoteInfo["振り飛車"]) }
                      others = xcontainer.players - [player]
                      if others.none? { |e| e.skill_set.has_skill?(Explain::NoteInfo["振り飛車"]) }
                        others.each { |e| e.skill_set.list_push(Explain::NoteInfo["対振り"]) }
                        xcontainer.players.each { |e| e.skill_set.list_push(Explain::NoteInfo["対抗型"]) }
                      end
                    end
                  end

                  # 大駒がない状態で勝ったら「背水の陣」
                  xcontainer.players.each do |player|
                    if player == xcontainer.win_player
                      if player.stronger_piece_have_count.zero?
                        player.skill_set.list_push(Explain::NoteInfo["背水の陣"])
                      end
                    end
                  end
                end

                # if xcontainer.players.any? { |e| e.skill_set.note_infos.include?(Explain::NoteInfo["振り飛車"]) }
                #   xcontainer.players.each do |player|
                #     player.skill_set.list_push(Explain::NoteInfo["相振り飛車"])
                #   end
                # end

                # 居玉判定
                if true
                  # if preset_info.key == :"平手"
                  xcontainer.players.each do |e|
                    # 14手以上の対局で一度も動かずに終了した
                    done = false
                    if !done
                      if xcontainer.turn_info.display_turn >= MIN_TURN && e.king_moved_counter.zero?
                        done = true
                      end
                    end
                    if !done
                      if xcontainer.outbreak_turn # 歩と角以外の交換があったか？
                        v = e.king_first_moved_turn
                        if v.nil? || v >= xcontainer.outbreak_turn  # 玉は動いていない、または戦いが激しくなってから動いた
                          done = true
                        end
                      end
                    end
                    if done
                      e.skill_set.list_push(Explain::DefenseInfo["居玉"])
                    end
                  end
                  # 両方居玉だったら備考に相居玉
                  if xcontainer.players.all? { |e| e.skill_set.has_skill?(Explain::DefenseInfo["居玉"]) }
                    xcontainer.players.each do |e|
                      e.skill_set.list_push(Explain::NoteInfo["相居玉"])
                    end
                  end
                  # end
                end
              end
            end
          end

          begin
            # ヘッダーに埋める
            Explain::TacticInfo.each do |e|
              xcontainer.players.each do |player|
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

      def judgment_message
        if e = last_action_info
          e.judgment_message(xcontainer)
        end
      end

      def last_action_info
        @last_action_info ||= yield_self do
          key = nil

          # エラーなら最優先
          if !key
            if @error_message
              key = :ILLEGAL_MOVE
            end
          end

          # 元の棋譜の記載を優先 (CSA語, 柿木語 のみ対応)
          if !key
            if @last_action_params
              v = @last_action_params[:last_action_key]
              if LastActionInfo[v]
                key = v
              end
            end
          end

          # 何の指定もないときだけ投了とする
          if !key
            if !@last_action_params
              key = :TORYO
            end
          end

          LastActionInfo[key]
        end
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
        ImageRenderer.new(xcontainer, options)
      end

      def to_image(options = {})
        image_renderer(options).to_blob_binary
      end

      ################################################################################

      def to_png(options = {})
        ImageRenderer.new(xcontainer, options.merge(image_format: "png")).to_blob_binary
      end

      def to_jpg(options = {})
        ImageRenderer.new(xcontainer, options.merge(image_format: "jpg")).to_blob_binary
      end

      def to_gif(options = {})
        ImageRenderer.new(xcontainer, options.merge(image_format: "gif")).to_blob_binary
      end

      def to_webp(options = {})
        ImageRenderer.new(xcontainer, options.merge(image_format: "webp")).to_blob_binary
      end

      ################################################################################

      def to_animation_mp4(options = {})
        AnimationMp4Builder.new(self, options).to_binary
      end

      def to_animation_gif(options = {})
        AnimationGifBuilder.new(self, options).to_binary
      end

      def to_animation_apng(options = {})
        AnimationApngBuilder.new(self, options).to_binary
      end

      def to_animation_webp(options = {})
        AnimationWebpBuilder.new(self, options).to_binary
      end

      def to_animation_zip(options = {})
        AnimationZipBuilder.new(self, options).to_binary
      end

      private

      def rikisen_hantei(xcontainer)
        # return if ENV["BIOSHOGI_ENV"] == "test"
        if xcontainer.turn_info.display_turn >= MIN_TURN
          # xcontainer.players.each do |player|
          #   if player.skill_set.power_battle?
          #     ChaosInfo.each do |chaos_info|
          #       if chaos_info.if_cond[xcontainer]
          #         player.skill_set.list_push(AttackInfo[chaos_info.key])
          #         break
          #       end
          #     end
          #   end
          # end
          # if xcontainer.players.all? { |e| e.skill_set.power_battle? }
          #   xcontainer.players.each do |e|
          #     e.skill_set.list_push(AttackInfo["乱戦"])
          #   end
          # else
          xcontainer.players.each do |e|
            e.skill_set.rikisen_check_process
          end
          # end
        end
      end

      def ainyugyoku_check(xcontainer)
        if xcontainer.players.all? { |e| e.skill_set.has_skill?(Explain::NoteInfo["入玉"]) }
          xcontainer.players.each do |player|
            player.skill_set.list_push(Explain::NoteInfo["相入玉"])
          end
        end
      end

      # 振り飛車でなければ居飛車
      def furibisya_denakereba_ibisha(xcontainer)
        xcontainer.players.each do |e|
          skill_set = e.skill_set
          if !skill_set.has_skill?(Explain::NoteInfo["振り飛車"]) && !skill_set.has_skill?(Explain::NoteInfo["居飛車"])
            e.skill_set.list_push(Explain::NoteInfo["居飛車"])
          end
        end
      end
    end
  end
end
