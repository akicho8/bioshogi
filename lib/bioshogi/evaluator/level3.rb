# frozen-string-literal: true

require "bioshogi/evaluator/base"
require "bioshogi/evaluator/opening_basic_table"
require "bioshogi/evaluator/attack_piece_weight_methods"

module Bioshogi
  module Evaluator
    class Level3 < Base
      include AttackPieceWeightMethods

      # 自分基準
      def score_compute
        w = 0
        players.each do |player|
          w += player.piece_box.score
          w += score1_of(player) * (1.0 - pressure_rate_hash(player)) # 序盤 * 序盤の重み
          w += score2_of(player) * pressure_rate_hash(player)         # 終盤 * 終盤の重み
        end
        w * player.location.value_sign
      end

      private

      # 序盤評価値
      def score1_of(player)
        w = 0
        player.soldiers.each do |e|
          w += e.abs_weight
          unless e.promoted
            if t = OpeningBasicTable[:field][e.piece.key]
              x, y = e.normalized_place.to_xy
              w += t[y][x]
            end
            if t = OpeningBasicTable[:advance][e.piece.key]
              w += t[e.bottom_spaces]
            end
          end
        end
        w
      end

      # 終盤評価値
      def score2_of(player)
        w = 0
        player.soldiers.each do |e|
          w += e.abs_weight
          w += soldier_score_for_scene(e, player.opponent_player.king_place, AttackWeightTable[:attack]) || 0
          w -= soldier_score_for_scene(e, player.king_place, AttackWeightTable[:defense]) || 0
        end
        w
      end

      # プレイヤーそれぞれの終盤度
      def pressure_rate_hash
        @pressure_rate_hash ||= players.inject({}) { |a, e| a.merge(e => e.pressure_rate) }
      end
    end
  end
end
