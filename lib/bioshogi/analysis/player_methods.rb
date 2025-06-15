# frozen-string-literal: true

module Bioshogi
  module Analysis
    module PlayerMethods
      attr_writer :king_moved_counter
      attr_accessor :king_place
      attr_accessor :king_first_moved_turn # 玉が最初に動いた手数

      def king_moved_counter
        @king_moved_counter ||= 0
      end

      # 玉の位置
      # FIXME: 消す
      def king_place
        @king_place ||= king_soldier&.place
      end

      def king_place_update
        @king_place = king_soldier&.place
      end

      def used_piece_counts
        @used_piece_counts ||= Hash.new(0)
      end
    end
  end
end
