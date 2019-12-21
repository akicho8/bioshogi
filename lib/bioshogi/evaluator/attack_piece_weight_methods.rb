# frozen-string-literal: true

require "bioshogi/evaluator/attack_weight_table"

module Bioshogi
  module Evaluator
    concern :AttackPieceWeightMethods do
      private

      def soldier_score_for_scene(e, king_place, table)
        if e.promoted || e.piece.key == :gold || e.piece.key == :silver
          # 相手玉
          if king_place
            sx, sy = e.place.to_xy
            tx, ty = king_place.to_xy
            gx = tx - sx
            gy = ty - sy

            oy = table.size / 2 # 8
            my = oy - gy                  # 8 - (-2) = 10

            mx = gx.abs             # 左右対象
            s = table.dig(my, mx)
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
