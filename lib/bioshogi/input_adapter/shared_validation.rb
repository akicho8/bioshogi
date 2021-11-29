# frozen-string-literal: true

module Bioshogi
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
            errors_add ReversePlayerPieceMoveError, "相手の駒を動かそうとしています。#{player.mediator.turn_info.turn_offset.next}手目の手番は#{player.location.name}#{player.call_name}ですが#{origin_soldier.location.name}#{player.opponent_player.call_name}の駒を持ちました"
          end

          if s = board.surface[soldier.place]
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

          if player.mediator.params[:validate_warp_skip]
          else
            # 初手 "25歩(27)" とした場合
            if !candidate_soldiers.include?(move_hand.origin_soldier)
              errors_add SoldierWarpError, "#{move_hand}としましたが#{place_from}から#{place}には移動できません"
            end
          end
        end

        if drop_trigger
          if board.surface[place]
            errors_add PieceAlredyExist, "駒の上に打とうとしています"
          end
        end
      end

      def soft_validations
        super

        if player.mediator.params[:validate_double_pawn_skip]
        else
          if drop_hand
            if collision_soldier = soldier.collision_pawn(board)
              errors_add DoublePawnCommonError, "二歩です。すでに#{collision_soldier}があるため#{drop_hand}ができません"
            end
          end
        end

        if !soldier.alive?
          errors_add DeadPieceRuleError, "#{soldier}は死に駒です。「#{soldier}成」の間違いかもしれません"
        end
      end
    end
  end
end
