# frozen-string-literal: true

module Bioshogi
  class Player
    module SoldierMethods
      def soldiers
        board.surface.values.find_all { |e| e.location == location }
      end

      def king_soldier
        soldiers.find { |e| e.piece.key == :king }
      end

      def to_s_soldiers
        soldiers.collect(&:name_without_location).sort.join(" ")
      end

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

      # 玉を除く駒が10毎以上相手陣に入っているか？
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
