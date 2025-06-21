# frozen-string-literal: true

module Bioshogi
  module Container
    concern :CoreMethods do
      attr_writer :board
      attr_accessor :initial_preset_info

      def initialize(params = {})
        self.params.update(params)
      end

      def after_setup
        initial_preset_info_set
      end

      def default_params
        {
          :analysis_feature        => false,
          :ki2_function            => true,
          :validate_feature        => true,
          :double_pawn_detect      => true, # 二歩を検出するか？
          :warp_detect             => true, # 角ワープを検出するか？
          :board_class             => Board,
          :last_action_info        => LastActionInfo[:TORYO],
        }
      end

      def params
        @params ||= default_params
      end

      def deep_dup
        Marshal.load(Marshal.dump(self))
      end

      def context_new(&block)
        yield deep_dup
      end

      def inspect
        to_s
      end

      def board
        @board ||= params[:board_class].new
      end

      def initial_preset_info_set
        unless defined?(@initial_preset_info)
          @initial_preset_info = board.preset_info
        end

        nil
      end

      def placement_from_bod(str)
        str = str.lines.collect(&:strip).join("\n")
        if md = str.match(/(?<board>^\+\-.*\-\+$)/m)
          board.placement_from_shape(md[:board])
        end
        str.scan(/(.*)の持駒：(.*)/) do |location_key, piece_str|
          player_at(location_key).pieces_set(piece_str)
        end

        if md = str.match(/^手数\s*(＝|=)\s*(?<counter>\d+)/)
          turn_info.turn_base = md[:counter].to_i
        end

        # 手合割は bod の仕様にはないはずだけどあれば駒落ちの判断材料にはなる
        if md = str.match(/^手合割：\s*(\S+)\s*/)
          if preset_info = PresetInfo.lookup(md.captures.first)
            turn_info.handicap = preset_info.handicap
          end
        end

        # 「上手」「下手」の名前がどこかに使われていれば駒落ち(雑)
        if Location.any? { |e| str.include?(e.handicap_name) }
          turn_info.handicap = true
        end

        # FIXME: 「先手番」のチェックがない
      end

      def placement_from_preset(preset_key = nil)
        preset_info = PresetInfo.fetch(preset_key || "平手")

        # 盤の反映
        board.placement_from_soldiers(preset_info.sorted_soldiers)

        # 持駒の反映
        preset_info.piece_boxes.each do |location_key, piece_str|
          player_at(location_key).pieces_set(piece_str)
        end

        # 手番の反映
        turn_info.handicap = preset_info.handicap

        Assertion.assert { turn_info.turn_base == 0 }
        Assertion.assert { turn_info.turn_offset == 0 }

        # 玉の位置を取得
        players.each(&:king_place_update)

        # TODO: ここで居玉判定をするべきかどうかの判定を入れたらいい？
      end

      # SFEN で初期配置する
      def placement_from_sfen(sfen_info)
        SfenImporter.new(self, sfen_info).import_initial
      end

      # SFEN のすべてを流し込む
      def load_from_sfen(sfen_info)
        SfenImporter.new(self, sfen_info).import_all
      end

      ################################################################################

      def headers_hash
        {}.merge(*players.collect(&:headers_hash))
      end

      ################################################################################
    end
  end
end
