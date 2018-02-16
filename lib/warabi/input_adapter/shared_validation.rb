# frozen-string-literal: true

module Warabi
  module InputAdapter
    concern :SharedValidation do
      def perform_validations
        super

        if move_hand
          if move_hand.promote_trigger?
            from = origin_soldier.point
            to = soldier.point
            if !from.promotable?(player.location) && !to.promotable?(player.location)
              errors_add NotPromotable, "#{from}から#{to}への移動では成れません"
            end
          end

          if move_hand.promote_trigger? && origin_soldier.promoted
            errors_add AlredyPromoted, "成りを明示しましたがすでに成っています"
          end

          if player.location != origin_soldier.location
            errors_add ReversePlayerPieceMoveError, "相手の駒を動かそうとしています"
          end

          if s = board.lookup(soldier.point)
            if s.location == player.location
              errors_add SamePlayerBattlerOverwrideError, "自分の駒を取ろうとしています"
            end
          end
        end
      end
    end
  end
end
