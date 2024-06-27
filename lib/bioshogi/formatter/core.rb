# frozen-string-literal: true

module Bioshogi
  module Formatter
    class Core
      attr_accessor :pi
      attr_accessor :parser_options

      def initialize(pi, parser_options)
        @pi = pi
        @parser_options = parser_options
      end

      delegate *[
        :to_bod,
        :screen_image_renderer,
        :to_image,
        :to_png,
        :to_jpg,
        :to_gif,
        :to_webp,
        :to_yomiage,
        :to_yomiage_list,
      ], to: :container

      def to_sfen(options = {})
        container.to_history_sfen(options)
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

      def container_run_once
        container
      end

      def container_class
        @parser_options[:container_class] || Container::Basic
      end

      def container_new
        container_class.new.tap do |e|
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

      # 画像生成のための container の初期状態を返す
      def container_for_image
        container = Container::Basic.new
        container.params.update({
            :skill_monitor_enable           => false,
            :skill_monitor_technique_enable => false,
            :candidate_enable               => false,
            :validate_enable                => false,
          })
        container_init(container) # FIXME: これ、必要ない SFEN を生成したりして遅い
        container
      end

      def container
        @container ||= container_new.tap do |e|
          container_init(e)
          container_run_all(e)
        end
      end

      # FIXME: container の最初の状態をコピーしておく
      def initial_container
        @initial_container ||= container_new.tap do |e|
          container_init(e)
        end
      end

      def container_init(container)
        if @pi.sfen_info
          container.placement_from_sfen(@pi.sfen_info)
        else
          players_piece_box_set(container)

          if @pi.board_source
            container.board.placement_from_shape(@pi.board_source)
          else
            preset_info = PresetInfo[pi.header["手合割"]] || PresetInfo["平手"]
            container.placement_from_preset(preset_info.key)
          end

          if pi.force_location
            container.turn_info.turn_base = pi.force_location.code
          end

          if pi.force_handicap
            container.turn_info.handicap = pi.force_handicap
          end
        end
        container.before_run_process # 最初の状態を記録
      end

      # 持駒を反映する
      def players_piece_box_set(container)
        pi.player_piece_boxes.each do |k, v|
          container.player_at(k).piece_box.set(v)
        end
      end

      # 盤面の指定があるとき、盤面だけを見て、手合割を得る
      def board_preset_info
        @board_preset_info ||= yield_self do
          if @pi.board_source
            Board.guess_preset_info(@pi.board_source)
          end
        end
      end

      # 手合割
      def preset_info
        @preset_info ||= @pi.force_preset_info
        @preset_info ||= initial_container.board.preset_info
        @preset_info ||= PresetInfo[pi.header["手合割"]]
        @preset_info ||= PresetInfo["平手"]
      end

      def container_run_all(container)
        Runner.new(self, container).call
        if @parser_options[:skill_monitor_enable]
          SkillEmbed.new(self, container).call
          StyleEmbed.new(self, container).call
        end
      end

      # FIXME: これは skill_embed のなかだけにあればよくね？
      def skill_set_hash
        @skill_set_hash ||= {}
      end

      # FIXME: メソッドが重複してね？
      def raw_header_part_hash
        pi.header.object.collect { |key, value|
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
          e.judgment_message(container)
        end
      end

      def last_action_info
        @last_action_info ||= yield_self do
          key = nil

          # エラーなら最優先
          unless key
            if @pi.error_message
              key = :ILLEGAL_MOVE
            end
          end

          # 元の棋譜の記載を優先 (CSA語, 柿木語 のみ対応)
          unless key
            if @pi.last_action_params
              v = @pi.last_action_params[:last_action_key]
              if LastActionInfo[v]
                key = v
              end
            end
          end

          # 何の指定もないときだけ投了とする
          unless key
            unless @pi.last_action_params
              key = :TORYO
            end
          end

          LastActionInfo[key]
        end
      end

      def used_seconds_at(index)
        @pi.move_infos.dig(index, :used_seconds).to_i
      end

      def error_message_part(comment_mark = "*")
        if @pi.error_message
          v = @pi.error_message.strip + "\n"
          s = "-" * 76 + "\n"
          [s, *v.lines, s].collect {|e| "#{comment_mark} #{e}" }.join
        end
      end
    end
  end
end
