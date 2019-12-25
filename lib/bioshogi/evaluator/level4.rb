# frozen-string-literal: true

require "bioshogi/evaluator/base"

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
        a = a_d_score_of(player, player.op, :attack)  # 敵玉の近くにいるスコア
        d = a_d_score_of(player, player.my, :defense) # 自玉の近くにいるスコア

        w = 0
        w += pressure[player.my] * a # 自分が敵玉に攻まっているほど、敵玉が危険なので、敵玉を攻める手のスコアを高くする
        w += pressure[player.op] * d # 相手が自玉に攻まっているほど、自玉が危険なので、自玉をまもる手のスコアを高くする
        w.to_i
      end
    end
  end
end
