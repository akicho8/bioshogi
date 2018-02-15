# frozen-string-literal: true

module Warabi
  module InputAdapter
    concern :Ki2PointMethods do
      def point
        absolute_point || same_point
      end

      def perform_validations
        super

        # 初手に同歩の場合
        if same? && !same_point
          raise BeforePointNotFound, "同に対する座標が不明です"
        end

        # 記事などで改ページしたとき明示的に "同歩" ではなく "同２四歩" と書く場合もあるとのことで同の座標が２四ではない場合
        if same? && same_point && absolute_point
          if same_point != absolute_point
            raise SamePointDifferent, "同は#{same_point}を意味しますが明示的に指定した移動先は#{absolute_point}です"
          end
        end

        # 結局座標がわからない場合
        if !point
          raise SyntaxDefact, "移動先の座標が不明です"
        end
      end

      private

      def absolute_point
        if v = input[:kif_point]
          Point.fetch(v)
        end
      end

      def same_point
        if hand_log = player.mediator.hand_logs.last
          hand_log.soldier.point
        end
      end

      def same?
        !!input[:ki2_same]
      end
    end
  end
end
