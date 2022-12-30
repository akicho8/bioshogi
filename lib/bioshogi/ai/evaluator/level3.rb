# frozen-string-literal: true

module Bioshogi
  module Ai
    module Evaluator
      class Level3 < Base
        def score_compute_report
          rows = player.self_and_opponent.collect do |player|
            {
              "先後"           => "#{player.location} #{player == self.player ? "自分" : ''}",
              "駒箱(常時加算)" => player.piece_box.score,
              "序盤"           => "#{opening_score(player)} * #{(1.0 - pressure[player]).round(1)} = #{opening_score(player) * (1.0 - pressure[player])}",
              "終盤"           => "#{final_stage_score(player)} * #{pressure[player].round(1)} = #{final_stage_score(player) * pressure[player]}",
              "序終盤合計"     => total_score(player),
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
          pressure
        end

        def total_score(player)
          w = 0
          w += player.piece_box.score
          w += opening_score(player) * (1.0 - pressure[player]) # 序盤 * 序盤の重み
          w += final_stage_score(player) * (0.0 + pressure[player]) # 終盤 * 終盤の重み
          w
        end

        # 序盤評価値
        def opening_score(player)
          w = 0
          player.soldiers.each do |e|
            w += e.abs_weight
            if !e.promoted # ← これを入れると序盤の「33角成」をダメな手だと教えられない、けどやっぱり成ってない駒だけを序盤駒とした方がいいか
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
        def final_stage_score(player)
          w = 0
          player.soldiers.each do |e|
            w += e.abs_weight
            w += a_d_score_of(player, player.op, :attack)  # 敵玉の近くにいるスコア
            w -= a_d_score_of(player, player.my, :defense) # 自玉の近くにいるスコア
          end
          w
        end

        # プレイヤーそれぞれの終盤度
        def pressure
          @pressure ||= players.inject({}) { |a, e| a.merge(e => e.pressure_rate) }
        end

        def opening_basic_table
          OpeningBasicTable
        end

        # player の 攻撃駒のスコア または 守り駒のスコア
        #
        # player: 自分
        # target: 対象玉 (自分側 or 相手側)
        # key: :attack or :defense
        def a_d_score_of(player, target, key)
          king_place = target.king_place
          table = AttackWeightTable[key]
          player.soldiers.sum { |e| soldier_score_for_scene(e, king_place, table) }
        end

        # 盤上の駒の位置による重み
        def soldier_score_for_scene(e, king_place, table)
          return 0 if !king_place

          if e.promoted || e.piece.key == :gold || e.piece.key == :silver
            # 相手の玉との距離
            sx, sy = e.place.to_xy
            tx, ty = king_place.to_xy
            gx = tx - sx
            gy = ty - sy

            # (mx, my) はテーブルのセルの位置
            # 金銀は上からの方が強いので縦は上と下でそれぞれ重みが違う
            oy = table.size / 2 # 8
            my = oy - gy        # 8 - (-2) = 10

            # mx は左右対象
            mx = gx.abs

            w = table.dig(my, mx)
            return 0 if !w
            # p ["#{__FILE__}:#{__LINE__}", __method__, e, w, s, [mx, my], king_place]
            w
          else
            0
          end
        end
      end
    end
  end
end
