module Bioshogi
  module Board
    module UpdateMethods
      def place_on(soldier, options = {})
        options = {
          validate: false,
        }.merge(options)

        if options[:validate]
          assert_cell_blank(soldier.place)
        end

        surface[soldier.place] = soldier
      end

      def pick_up(place)
        soldier = safe_delete_on(place)
        if !soldier
          raise NotFoundOnBoard, "#{place}の位置には何もありません"
        end
        soldier
      end

      def safe_delete_on(place)
        surface.delete(place)
      end

      def all_clear
        surface.clear
      end

      # for DSL
      # 引数の種類がわかっているなら専用メソッドを使うべき
      def placement_from_any(v)
        case
        when PresetInfo.lookup(v)
          placement_from_preset(v)
        when BoardParser.accept?(v)
          placement_from_shape(v)
        when v.kind_of?(String) && !InputParser.scan(v).empty?
          placement_from_human(v)
        else
          raise ArgumentError, v.inspect
        end
      end

      # 手合割で設定
      def placement_from_preset(preset_key)
        placement_from_soldiers(Soldier.preset_soldiers(preset_key))
      end

      # 柿木盤を読み取って反映する
      # 毎回読み取るため遅い
      def placement_from_shape(str)
        placement_from_soldiers(BoardParser.parse(str).soldier_box)
      end

      # 詰将棋の配置の読み上げのような表記で盤に反映する
      # placement_from_human("△51玉 ▲59玉")
      def placement_from_human(str)
        soldiers = InputParser.scan(str).collect { |s| Soldier.from_str(s) }
        placement_from_soldiers(soldiers)
      end

      # まとめて追加で置く
      def placement_from_soldiers(soldiers)
        soldiers.each { |e| place_on(e) }
      end

      private

      def assert_cell_blank(place)
        if surface.has_key?(place)
          raise PieceAlredyExist, "空のはずの#{place}に駒があります\n#{self}"
        end
      end
    end
  end
end
