# frozen-string-literal: true

module Bioshogi
  module Formatter
    class Core
      attr_accessor :mi
      attr_accessor :parser_options

      def initialize(mi, parser_options)
        @mi = mi
        @parser_options = parser_options
      end

      delegate *[
        :to_bod,
        :image_renderer,
        :to_image,
        :to_png,
        :to_jpg,
        :to_gif,
        :to_webp,
        :to_yomiage,
        :to_yomiage_list,
      ], to: :xcontainer

      def to_sfen(options = {})
        xcontainer.to_history_sfen(options)
      end

      def to_kif(options = {})
        KifBuilder.new(self, options).to_s
      end

      def to_ki2(options = {})
        Ki2Builder.new(self, options).to_s
      end

      def to_csa(options = {})
        CsaBuilder.new(self, options).to_s
      end

      def to_akf(options = {})
        AkfBuilder.new(self, options).to_h
      end

      ################################################################################

      def to_animation_mp4(options = {})
        Animation::AnimationMp4Builder.new(self, options).to_binary
      end

      def to_animation_gif(options = {})
        Animation::AnimationGifBuilder.new(self, options).to_binary
      end

      def to_animation_apng(options = {})
        Animation::AnimationApngBuilder.new(self, options).to_binary
      end

      def to_animation_webp(options = {})
        Animation::AnimationWebpBuilder.new(self, options).to_binary
      end

      def to_animation_zip(options = {})
        Animation::AnimationZipBuilder.new(self, options).to_binary
      end

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
        xcontainer_init(xcontainer) # FIXME: これ、必要ない SFEN を生成したりして遅い
        xcontainer
      end

      def xcontainer
        @xcontainer ||= xcontainer_new.tap do |e|
          xcontainer_init(e)
          xcontainer_run_all(e)
        end
      end

      # FIXME: xcontainer の最初の状態をコピーしておく
      def initial_xcontainer
        @initial_xcontainer ||= xcontainer_new.tap do |e|
          xcontainer_init(e)
        end
      end

      def xcontainer_init(xcontainer)
        if @mi.sfen_info
          xcontainer.placement_from_sfen(@mi.sfen_info)
        else
          players_piece_box_set(xcontainer)

          if @mi.board_source
            xcontainer.board.placement_from_shape(@mi.board_source)
          else
            preset_info = PresetInfo[mi.header["手合割"]] || PresetInfo["平手"]
            xcontainer.placement_from_preset(preset_info.key)
          end

          if mi.force_location
            xcontainer.turn_info.turn_base = mi.force_location.code
          end

          if mi.force_handicap
            xcontainer.turn_info.handicap = mi.force_handicap
          end
        end
        xcontainer.before_run_process # 最初の状態を記録
      end

      # 持駒を反映する
      def players_piece_box_set(xcontainer)
        mi.player_piece_boxes.each do |k, v|
          xcontainer.player_at(k).piece_box.set(v)
        end
      end

      # 盤面の指定があるとき、盤面だけを見て、手合割を得る
      def board_preset_info
        @board_preset_info ||= yield_self do
          if @mi.board_source
            Board.guess_preset_info(@mi.board_source)
          end
        end
      end

      # 手合割
      def preset_info
        @preset_info ||= @mi.force_preset_info
        @preset_info ||= initial_xcontainer.board.preset_info
        @preset_info ||= PresetInfo[mi.header["手合割"]]
        @preset_info ||= PresetInfo["平手"]
      end

      def xcontainer_run_all(xcontainer)
        Runner.new(self, xcontainer).perform
        if @parser_options[:skill_monitor_enable]
          SkillEmbed.new(self, xcontainer).perform
        end
      end

      def skill_set_hash
        @skill_set_hash ||= {}
      end

      def raw_header_part_hash
        mi.header.object.collect { |key, value|
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
            if @mi.error_message
              key = :ILLEGAL_MOVE
            end
          end

          # 元の棋譜の記載を優先 (CSA語, 柿木語 のみ対応)
          if !key
            if @mi.last_action_params
              v = @mi.last_action_params[:last_action_key]
              if LastActionInfo[v]
                key = v
              end
            end
          end

          # 何の指定もないときだけ投了とする
          if !key
            if !@mi.last_action_params
              key = :TORYO
            end
          end

          LastActionInfo[key]
        end
      end

      def used_seconds_at(index)
        @mi.move_infos.dig(index, :used_seconds).to_i
      end

      def error_message_part(comment_mark = "*")
        if @mi.error_message
          v = @mi.error_message.strip + "\n"
          s = "-" * 76 + "\n"
          [s, *v.lines, s].collect {|e| "#{comment_mark} #{e}" }.join
        end
      end
    end
  end
end
