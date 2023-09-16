# frozen-string-literal: true

module Bioshogi
  class Player
    module OtherMethods
      attr_writer :king_moved_counter
      attr_accessor :king_place
      attr_accessor :king_first_moved_turn # 玉が最初に動いた手数
      attr_accessor :death_counter         # 駒が死んだ数

      def king_moved_counter
        @king_moved_counter ||= 0
      end

      def king_place
        @king_place ||= king_soldier&.place
      end

      def king_place_update
        @king_place = king_soldier&.place
      end

      def used_piece_counts
        @used_piece_counts ||= Hash.new(0)
      end

      # 大駒コンプリートしている？
      def stronger_piece_completed?
        stronger_piece_have_count >= 4
      end

      def stronger_piece_have_count
        c = 0

        # 持駒の大駒
        c += piece_box[:rook] || 0
        c += piece_box[:bishop] || 0

        # 盤上の大駒
        key = location.key
        c += board.piece_count_of(key, :rook)
        c += board.piece_count_of(key, :bishop)

        c
      end

      # 入玉宣言時の得点合計(仮)
      def ek_score_without_cond
        soldiers_ek_score + piece_box.ek_score
      end

      # 入玉宣言時の得点合計(最終)
      def ek_score_with_cond
        if king_soldier_entered? && many_soliders_are_in_the_opponent_area?
          ek_score_without_cond
        end
      end
    end
  end
end
