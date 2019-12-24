# frozen-string-literal: true

require "bioshogi/evaluator/base"
require "bioshogi/evaluator/attack_weight_table"
require "bioshogi/evaluator/opening_basic_table"

module Bioshogi
  module Evaluator
    class Level4 < Level3
      def score_compute_report
        rows = player.self_and_opponent.collect do |player|
          {
            "先後"           => "#{player.location} #{player == self.player ? "自分" : ''}",
            "駒箱(常時加算)" => player.piece_box.score,
            "駒組み"         => score1(player),
            "終盤"           => score2(player),
            "合計"           => total_score(player),
          }
        end
        rows += [{"差(自分基準)" => score_compute}]
      end

      private

      def total_score(player)
        w = 0
        w += player.piece_box.score
        w += score1(player) # 駒組み
        w += score2(player) # 中終盤
        w
      end

      # 中終盤スコア
      def score2(player)
        # ↓共通化

        # 敵玉の近くにいるスコア
        king_place = player.op.king_place
        table = AttackWeightTable[:attack]
        a = player.soldiers.sum { |e| soldier_score_for_scene(e, king_place, table)  }

        # 自玉の近くにいるスコア
        king_place = player.my.king_place
        table = AttackWeightTable[:defense]
        d = player.soldiers.sum { |e| soldier_score_for_scene(e, king_place, table) } # 守備スコア

        w = 0
        w += pressure[player.my] * a # 自分が敵玉に攻まっているほど、敵玉が危険なので、敵玉を攻める手のスコアを高くする
        w += pressure[player.op] * d # 相手が自玉に攻まっているほど、自玉が危険なので、自玉をまもる手のスコアを高くする
        w.to_i
      end
    end
  end
end
