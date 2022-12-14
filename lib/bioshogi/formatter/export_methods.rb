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
        Runner.new(self, xcontainer).perform
        if @parser_options[:skill_monitor_enable]
          SkillChecker.new(self, xcontainer).perform
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
    end
  end
end
