# frozen-string-literal: true

# 大駒の位置をO(1)で得るための履歴
module Bioshogi
  module Analysis
    module SoldierLookupTableMethods
      # 置く
      def place_on(soldier, options = {})
        super
        (soldier_lookup_hash1[soldier.to_key1] ||= []) << soldier
        (soldier_lookup_hash2[soldier.to_key2] ||= []) << soldier
      end

      # 消す
      def safe_delete_on(place)
        super.tap do |soldier|
          if soldier
            soldier_lookup_hash1[soldier.to_key1].delete(soldier)
            soldier_lookup_hash2[soldier.to_key2].delete(soldier)
          end
        end
      end

      # 全消し
      def all_clear
        super
        soldier_lookup_hash1.clear
        soldier_lookup_hash2.clear
      end

      def soldiers_lookup1(location_key, piece_key)
        soldier_lookup_hash1[:"#{location_key}/#{piece_key}"] || []
      end

      def soldiers_lookup2(location_key, piece_key, promoted)
        soldier_lookup_hash2[:"#{location_key}/#{piece_key}/#{promoted}"] || []
      end

      private

      def soldier_lookup_hash1
        @soldier_lookup_hash1 ||= {}
      end

      def soldier_lookup_hash2
        @soldier_lookup_hash2 ||= {}
      end
    end
  end
end
