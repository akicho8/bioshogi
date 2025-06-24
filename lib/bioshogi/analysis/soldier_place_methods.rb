# frozen-string-literal: true

# 大駒の位置をO(1)で得るための履歴
module Bioshogi
  module Analysis
    module SoldierPlaceMethods
      # 置く
      def place_on(soldier, options = {})
        super
        av = (soldier_places_hash[soldier.location.key][soldier.piece.key] ||= [])
        av << soldier
      end

      # 消す
      def safe_delete_on(place)
        super.tap do |soldier|
          if soldier
            soldier_places_hash[soldier.location.key][soldier.piece.key].delete(soldier)
          end
        end
      end

      # 全消し
      def all_clear
        super
        soldier_places_hash.each_value(&:clear)
      end

      def soldiers_lookup(location_key, piece_key)
        Assertion.assert { location_key.kind_of? Symbol }
        Assertion.assert { piece_key.kind_of? Symbol }

        soldier_places_hash.fetch(location_key)[piece_key] || []
      end

      private

      def soldier_places_hash
        @soldier_places_hash ||= Location.inject({}) { |a, e| a.merge(e.key => {}) }
      end
    end
  end
end
