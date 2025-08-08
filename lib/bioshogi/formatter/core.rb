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

      def container_default_params
        params = @parser_options.slice(*[
            :analysis_feature,
            :ki2_function,
            :validate_feature,
            :double_pawn_detect,
            :warp_detect,
          ])

        # xparser を渡すのではなく必要なパラメータだけ渡す
        params[:preset_info_or_nil]     = preset_info_or_nil           # 手合割
        params[:win_side_location]      = pi.header.win_side_location # 勝敗がついた側がわかっている (強)
        params[:input_last_action_info] = pi.input_last_action_info   # 結末 (都詰めなどの判定に必要)

        params
      end

      def container_new
        container_class.new(container_default_params)
      end

      # 画像生成のための container の初期状態を返す
      def container_for_image
        params = {
          :analysis_feature        => false,
          :ki2_function            => false,
          :validate_feature        => false,
        }

        container = Container::Basic.new(params) # FIXME: Container::Fast を使うこと
        container_init(container) # FIXME: これ、必要ない SFEN を生成したりして遅い
        container
      end

      def container
        @container ||= container_new.tap do |e|
          container_init(e)
          container_run_all(e)
        end
      end

      # FIXME: container の最初の状態をコピーしておく → 知っていればいい情報だけをとっておく
      def initial_container
        @initial_container ||= container_new.tap do |e|
          container_init(e)
        end
      end

      def container_init(container)
        if pi.sfen_info
          container.placement_from_sfen(pi.sfen_info)
        else
          players_piece_box_set(container)

          if pi.board_source
            container.board.placement_from_shape(pi.board_source)
          else
            preset_info = PresetInfo[pi.header["手合割"]] || PresetInfo["平手"]
            container.placement_from_preset(preset_info.key)
          end

          if false
            # 本来はシンプルに次のようにすればいいのだけど、
            # 「駒落ち」かつ「上手番」の2つの指定があったとき、両方指定すると 1 + 1 = 2 となり
            # 逆に先手から始まってしまい、「【反則】下手の手番で上手が着手しました」となる
            if pi.force_handicap
              container.turn_info.handicap = pi.force_handicap
            end
            if pi.force_location
              container.turn_info.turn_base = pi.force_location.code
            end
          else
            # とりあえず優先して駒落ちフラグを設定する
            if pi.force_handicap
              container.turn_info.handicap = pi.force_handicap
            end

            # 次に「希望の手番」を設定する。force_location としているがもう force ではなくなっている。
            case
            when container.turn_info.handicap && pi.force_location&.key == :white
              # 「駒落ち(設定済み)」x「△開始」= さわらない
            when !container.turn_info.handicap && pi.force_location&.key == :black
              # 「平手」x「▲開始」= さわらない
            when pi.force_location
              # 「平手」x「△開始」
              # 「駒落ち」x「▲開始」
              container.turn_info.turn_base = pi.force_location.code
            end
          end
        end

        container.after_setup # 最初の状態を記録 (MEMO: ここで呼ぶのはおかしくないか？)
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
          if pi.board_source
            Board.guess_preset_info(pi.board_source)
          end
        end
      end

      # 手合割
      def preset_info
        @preset_info ||= preset_info_or_nil || PresetInfo["平手"]
      end

      # 手合割(なければ nil)
      def preset_info_or_nil
        unless defined?(@preset_info_or_nil)
          @preset_info_or_nil ||= pi.force_preset_info
          @preset_info_or_nil ||= initial_container.board.preset_info
          @preset_info_or_nil ||= PresetInfo[pi.header["手合割"]]
        end

        @preset_info_or_nil
      end

      def container_run_all(container)
        Runner.new(self, container).call
        if @parser_options[:analysis_feature]
          pi.header.object.update(container.to_header_h)

          if e = pi.output_last_action_info
            pi.header["結末"] = e.kakinoki_word
          end
        end
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
        if e = pi.output_last_action_info
          e.judgment_message(container)
        end
      end
    end
  end
end
