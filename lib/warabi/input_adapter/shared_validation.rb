# frozen-string-literal: true

module Warabi
  module InputAdapter
    concern :SharedValidation do
      def hard_validations
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

      def soft_validations
        super

        if direct_hand
          if collision_soldier = soldier.collision_pawn(board)
            errors_add DoublePawnCommonError, "二歩です。すでに#{collision_soldier}があるため#{direct_hand}ができません"
          end
        end

        if !soldier.alive?
          errors_add DeadPieceRuleError, "#{soldier}は死に駒です。「#{soldier}成」の間違いの可能性があります"
        end
      end
    end
  end
end
