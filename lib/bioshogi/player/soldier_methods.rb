# frozen-string-literal: true

module Bioshogi
  class Player
    module SoldierMethods
      ################################################################################

      # O(1)
      def soldiers_lookup1(piece_key)
        board.soldiers_lookup1(location.key, piece_key)
      end

      # O(1)
      def king_soldier
        soldiers_lookup1(:king).first
      end

      def king_soldier_only_one_exist?
        soldiers_lookup1(:king).size == 1
      end

      ################################################################################

      # O(1)
      def soldiers_lookup2(...)
        board.soldiers_lookup2(location.key, ...)
      end

      ################################################################################

      # O(n)
      def soldiers
        board.surface.values.find_all { |e| e.location == location }
      end

      def to_s_soldiers
        soldiers.collect(&:name_without_location).sort.join(" ")
      end

      ################################################################################ 得点

      # 入玉宣言時の盤上にある駒の得点合計
      def soldiers_ek_score
        soldiers.sum(&:ek_score)
      end

      # 入玉している？
      def king_soldier_entered?
        if soldier = king_soldier
          soldier.place.opp_side?(location)
        end
      end

      # 玉を除く駒が10枚以上相手陣に入っているか？
      def many_soliders_are_in_the_opponent_area?
        entered_soldiers.count >= Piece::EkScoreInfo::N_SOLIDIERS_IN_OPPONENT_AREA_WITHOUT_KING
      end

      # 相手陣に入っている玉を除く駒
      def entered_soldiers
        soldiers.find_all do |e|
          if e.piece.key != :king
            e.place.opp_side?(location)
          end
        end
      end
    end
  end
end
