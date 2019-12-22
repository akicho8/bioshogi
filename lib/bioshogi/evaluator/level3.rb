# frozen-string-literal: true

require "bioshogi/evaluator/base"
require "bioshogi/evaluator/attack_weight_table"
require "bioshogi/evaluator/opening_basic_table"

module Bioshogi
  module Evaluator
    class Level3 < Base
      # 自分基準
      def score_compute
        player_score(player) - player_score(player.opponent_player)
      end

      def score_compute_report
        rows = player.self_and_opponent.collect do |player|
          {
            "先後"           => "#{player.location} #{player == self.player ? "自分" : ''}",
            "駒箱(常時加算)" => player.piece_box.score,
            "序盤"           => "#{score1_of(player)} * #{(1.0 - pressure_rate_hash[player]).round(1)} = #{score1_of(player) * (1.0 - pressure_rate_hash[player])}",
            "終盤"           => "#{score2_of(player)} * #{pressure_rate_hash[player].round(1)} = #{score2_of(player) * pressure_rate_hash[player]}",
            "序終盤合計"     => player_score(player),
          }
        end
        rows += [{"全体" => score_compute}]
      end

      private

      def initialize(*)
        super

        # 途中で呼ばれると盤面が変化している場合があるので最初に作っておく
        #
        # YSS の場合は歩香桂以外では探索中でもきちんと動いた玉を考慮している
        # > http://www.yss-aya.com/book.html
        # > なお、高速化のため、歩、香、桂の小駒に対しては、探索途中で王が動いても再計算せずに、探索前の王の位置から増減表を作って加算している。
        #
        pressure_rate_hash
      end

      def player_score(player)
        w = 0
        w += player.piece_box.score
        w += score1_of(player) * (1.0 - pressure_rate_hash[player]) # 序盤 * 序盤の重み
        w += score2_of(player) * pressure_rate_hash[player]         # 終盤 * 終盤の重み
      end

      # 序盤評価値
      def score1_of(player)
        w = 0
        player.soldiers.each do |e|
          w += e.abs_weight
          unless e.promoted
            if t = opening_basic_table[:field][e.piece.key]
              x, y = e.normalized_place.to_xy
              w += t[y][x]
            end
            if t = opening_basic_table[:advance][e.piece.key]
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

      def opening_basic_table
        OpeningBasicTable
      end

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
