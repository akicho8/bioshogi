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
    end
  end
end
