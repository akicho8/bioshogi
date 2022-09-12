# frozen-string-literal: true

module Bioshogi
  module InputAdapter
    concern :Ki2PlaceMethods do
      def place
        absolute_place || same_place
      end

      def hard_validations
        super

        # 初手に同歩の場合
        if same? && !same_place
          errors_add BeforePlaceNotFound, "同に対する座標が不明です"
        end

        # 記事などで改ページしたとき明示的に "同歩" ではなく "同２四歩" と書く場合もあるとのことで同の座標が２四ではない場合
        if same? && same_place && absolute_place
          if same_place != absolute_place
            errors_add SamePlaceDifferent, "同は#{same_place}を意味しますが明示的に指定した移動先は#{absolute_place}です"
          end
        end

        # 結局座標がわからない場合
        if !place
          errors_add SyntaxDefact, "移動先の座標が不明です"
        end
      end

      private

      def absolute_place
        if v = input[:kif_place]
          Place.fetch(v)
        end
      end

      def same_place
        if hand_log = player.xcontainer.hand_logs.last
          hand_log.soldier.place
        end
      end

      def same?
        !!input[:ki2_same]
      end
    end
  end
end
