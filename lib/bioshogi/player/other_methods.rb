# frozen-string-literal: true

module Bioshogi
  class Player
    module OtherMethods
      STRONG_PIECE_ALL_COUNT = Location.count * Piece.strong_pieces.count

      ################################################################################

      # 大駒コンプリートしている？
      def strong_piece_completed?
        strong_piece_have_count >= STRONG_PIECE_ALL_COUNT
      end

      # 大駒の数
      def strong_piece_have_count
        Piece.strong_pieces.sum do |e|
          piece_box.fetch(e.key, 0) + board.soldiers_count[location.key][e.key]
        end
      end

      ################################################################################

      # 玉単騎状態？
      def bare_king?
        if board.soldiers_count_per_location[location.key] == 1 # 盤上の自分の駒が1つ
          if soldiers_lookup(:king).present?                    # 玉がいる
            piece_box.empty?                                    # 持駒がない
          end
        end
      end

      ################################################################################

      # 入玉宣言時の得点合計(仮)
      def ek_score_without_cond
        soldiers_ek_score + piece_box.ek_score
      end

      # 入玉宣言時の得点合計(最終)
      def ek_score_with_cond
        # 「入玉」かつ「玉を除く駒が10毎以上相手陣に入っている」なら
        if king_soldier_entered? && many_soliders_are_in_the_opponent_area?
          ek_score_without_cond
        end
      end

      ################################################################################

      # 総合得点(先後とも正)
      def current_score
        soldiers.sum(&:abs_weight) + piece_box.score
      end

      # 圧倒的なスコアがある？
      def overwhelming_score?
        current_score >= Analysis::ClusterScoreInfo["圧倒的な駒得"].min_score
      end

      ################################################################################
    end
  end
end
