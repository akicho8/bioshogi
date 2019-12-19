# frozen-string-literal: true

require "bioshogi/evaluator/base"
require "bioshogi/evaluator/opening_basic_table"
require "bioshogi/evaluator/attack_piece_weight_methods"

module Bioshogi
  module Evaluator
    class Level3 < Base
      include AttackPieceWeightMethods

      def danger_level
        score = 0
        board.surface.each_value.each do |e|
          if e.top_spaces <= 3
            if e.promoted || e.piece.key == :gold || e.piece.key == :silver
              score += 1
            end
          end
        end

        mediator.players.each do |e|
          e.piece_box.each do |piece, count|
            if piece.key == :gold || piece.key == :silver
              score += 1
            end
          end
        end

        score
      end

      private

      # 評価すること
      # ・盤上の駒の価値
      # ・序盤で歩をつく
      # ・玉を追いつめる
      def soldier_score(e)
        w = e.abs_weight

        unless e.promoted
          if t = OpeningBasicTable[:field][e.piece.key]
            x, y = e.normalized_place.to_xy
            w += t[y][x]
          end
          if t = OpeningBasicTable[:advance][e.piece.key]
            s = t[e.bottom_spaces]
            w += s
          end
        end

        w += soldier_score_for_attack(e) || 0

        w
      end

    end
  end
end
