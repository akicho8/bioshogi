# frozen-string-literal: true

#
# 盤上の駒数を素早く得るための仕組み
#

module Bioshogi
  module Analysis
    module BoardPieceCountsMethods
      def place_on(soldier, options = {})
        super
        specific_piece_counts[soldier.location.key].increment(soldier.piece.key)
        location_piece_counts.increment(soldier.location.key)
      end

      def safe_delete_on(place)
        super.tap do |soldier|
          if soldier
            specific_piece_counts[soldier.location.key].decrement(soldier.piece.key)
            location_piece_counts.decrement(soldier.location.key)
          end
        end
      end

      def all_clear
        super
        specific_piece_counts.each_value(&:clear)
        location_piece_counts.clear
      end

      ################################################################################ 「大駒コンプリート」チェック用

      # 「先後と駒」をキーにして駒数を得る
      def specific_piece_counts
        @specific_piece_counts ||= Location.inject({}) { |a, e| a.merge(e.key => CounterHash.new) }
      end

      # board.specific_piece_count_for(:black, :rook) で盤上の飛車の個数を取れる
      def specific_piece_count_for(location_key, piece_key)
        specific_piece_counts[location_key][piece_key]
      end

      ################################################################################ 「全駒」チェック用

      # 「先後」をキーにして駒数を得る
      # zengoma?
      def location_piece_counts
        @location_piece_counts ||= CounterHash.new
      end

      ################################################################################
    end
  end
end
