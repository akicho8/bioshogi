# frozen-string-literal: true

#
# 大駒の位置をO(1)で得るための履歴
#

module Bioshogi
  module Analysis
    module CoreSoldierPlaceMethods
      def place_on(soldier, options = {})
        super
        if soldier.piece.core_piece?
          core_soldier_places_hash[soldier.location.key][soldier.piece.key] = soldier
        end
      end

      def safe_delete_on(place)
        super.tap do |soldier|
          if soldier
            if soldier.piece.core_piece?
              core_soldier_places_hash[soldier.location.key].delete(soldier.piece.key)
            end
          end
        end
      end

      def all_clear
        super
        core_soldier_places_hash.each_value(&:clear)
      end

      ################################################################################ 玉飛角の位置を瞬時に得るためのテーブル

      def core_soldier_places_hash
        @core_soldier_places_hash ||= Location.inject({}) { |a, e| a.merge(e.key => {}) }
      end

      # # board.specific_piece_count_for(:black, :rook) で盤上の飛車の個数を取れる
      def core_soldier_places_for(location_key, piece_key)
        core_soldier_places_hash.dig(location_key, piece_key)&.place
      end

      # # board.specific_piece_count_for(:black, :rook) で盤上の飛車の個数を取れる
      # def specific_piece_count_for(location_key, piece_key)
      #   core_soldier_places_hash[location_key][piece_key]
      # end

      # ################################################################################ 「全駒」チェック用
      #
      # # 「先後」をキーにして駒数を得る
      # # zengoma?
      # def location_piece_counts
      #   @location_piece_counts ||= CounterHash.new
      # end
      #
      # ################################################################################
    end
  end
end
