# frozen-string-literal: true
# 駒柱判定用

module Bioshogi
  module Analysis
    module BoardPillerMethods
      attr_accessor :piece_piller_by_latest_piece

      def place_on(soldier, options = {})
        super

        c = piller_counts[soldier.place.x.value] + 1
        if c > Dimension::PlaceY.dimension
          raise MustNotHappen, "#{soldier.place.x.hankaku_number}の列に#{c}個目の駒を配置しようとしています。棋譜を二重に読ませようとしていませんか？"
        end
        piller_counts[soldier.place.x.value] = c
        self.piece_piller_by_latest_piece = (c == Dimension::PlaceY.dimension) # 最後の駒が反映される
      end

      # 現在の状態は駒柱がある状態か？
      def piece_piller_by_latest_piece?
        piller_counts.each_value.any? { |c| c >= Dimension::PlaceY.dimension } # O(n) になるので使いたくない
      end

      def all_clear
        super

        piller_counts.clear
        self.piece_piller_by_latest_piece = false
      end

      def safe_delete_on(*)
        super.tap do |soldier|
          if soldier
            c = piller_counts[soldier.place.x.value]
            c -= 1
            if c.negative?
              raise "must not happen"
            end
            piller_counts[soldier.place.x.value] = c
            self.piece_piller_by_latest_piece = (c == Dimension::PlaceY.dimension)
          end
        end
      end

      private

      def piller_counts
        @piller_counts ||= Hash.new(0)
      end
    end
  end
end
