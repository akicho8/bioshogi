# frozen-string-literal: true

require "bioshogi/evaluator/attack_weight_table"

module Bioshogi
  module Evaluator
    concern :AttackPieceWeightMethods do
      private

      def soldier_score_for_attack(e)
        if e.promoted || e.piece.key == :gold || e.piece.key == :silver
          # 相手玉
          king_place = mediator.player_at(e.location.flip).king_place
          if king_place
            sx, sy = e.place.to_xy
            tx, ty = king_place.to_xy
            gx = tx - sx
            gy = ty - sy

            oy = AttackWeightTable.size / 2 # 8
            my = oy - gy                  # 8 - (-2) = 10

            mx = gx.abs             # 左右対象
            s = AttackWeightTable.dig(my, mx)
            if s
              # p ["#{__FILE__}:#{__LINE__}", __method__, e, w, s, [mx, my], king_place]
              s
            end
          end
        end
      end
    end
  end
end
