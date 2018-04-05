# frozen-string-literal: true

module Warabi
  module InputAdapter
    concern :SharedValidation do
      def hard_validations
        super

        if move_hand
          if move_hand.promote_trigger? && origin_soldier.promoted
            errors_add AlredyPromoted, "成りを明示しましたがすでに成っています"
          end

          if move_hand.promote_trigger?
            if !origin_soldier.next_promotable?(place)
              errors_add NotPromotable, "#{origin_soldier.place}から#{place}への移動では成れません"
            end
          end

          if player.location != origin_soldier.location
            errors_add ReversePlayerPieceMoveError, "相手の駒を動かそうとしています"
          end

          if s = board.lookup(soldier.place)
            if s.location == player.location
              errors_add SamePlayerBattlerOverwrideError, "自分の駒を取ろうとしています"
            end
          end

          # この検証を外すと次の !candidate_soldiers.include?(move_hand.origin_soldier) の検証にひっかかるので外してもよいけど、
          # エラーの原因を明確にするために入れてある
          if !promote_trigger && origin_soldier
            if origin_soldier.promoted && !promoted
              errors_add PromotedPieceToNormalPiece, "成った状態から成らない状態に戻れません"
            end
          end

          # 初手 "25歩(27)" とした場合
          if !candidate_soldiers.include?(move_hand.origin_soldier)
            errors_add CandidateSoldiersNotInclude, "#{move_hand}としましたが#{place_from}から#{place}に移動することはできません"
          end
        end

        if drop_trigger
          if board.lookup(place)
            errors_add PieceAlredyExist, "駒の上に打とうとしています"
          end
        end
      end

      def soft_validations
        super

        if drop_hand
          if collision_soldier = soldier.collision_pawn(board)
            errors_add DoublePawnCommonError, "二歩です。すでに#{collision_soldier}があるため#{drop_hand}ができません"
          end
        end

        if !soldier.alive?
          errors_add DeadPieceRuleError, "#{soldier}は死に駒です。「#{soldier}成」の間違いの可能性があります"
        end
      end
    end
  end
end
