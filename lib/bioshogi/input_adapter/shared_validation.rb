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
            unless origin_soldier.tsugini_nareru_on?(place)
              errors_add NotPromotable, "#{origin_soldier.place}から#{place}への移動では成れません"
            end
          end

          if player.location != origin_soldier.location
            # player.location.name         => ▲
            # origin_soldier.location.name => △
            message = []
            message << "相手の駒を動かそうとしています"
            message.concat(turn_error_messages)
            message = message.join("。")
            errors_add ReversePlayerPieceMoveError, message
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

          if player.container.params[:warp_detect]
            # 初手 "25歩(27)" とした場合
            unless candidate_soldiers.include?(move_hand.origin_soldier)
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

        if player.container.params[:double_pawn_detect]
          if drop_hand
            if collision_soldier = soldier.collision_pawn(board)
              errors_add DoublePawnCommonError, "二歩です。すでに#{collision_soldier}があるため#{drop_hand}ができません"
            end
          end
        end

        unless soldier.alive?
          errors_add DeadPieceRuleError, "#{soldier}は死に駒です。「#{soldier}成」の間違いかもしれません"
        end
      end

      def turn_error_messages
        av = []
        av << "手番違いかもしれません"

        av << yield_self {
          m = []
          m << "#{player.container.turn_info.turn_offset.next}手目は#{player.location.pentagon_mark}の手番ですが"
          m << "#{player.opponent_player.location.pentagon_mark}が着手しました"
          m.join
        }

        if player.container.turn_info.handicap?
          av << "手合割は「駒落ち」です"
        end

        if player.container.turn_info.display_turn == 0
          if player.container.turn_info.handicap?
            av << "平手で手番のハンデを貰っている場合は☗側が初手を指してください"
          end
        end

        if player.container.turn_info.handicap?
          av << "詰将棋で「上手・下手」の表記を用いている場合は「後手・先手」に直してください"
        end

        # if player.container.turn_info.display_turn > 0
        #   av << "将棋倶楽部24の場合、反則(二手指し)による不正な棋譜になっている場合があります"
        # end

        av
      end
    end
  end
end
