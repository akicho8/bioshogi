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

        hv = (soldier_places_hash2[soldier.location.key][soldier.piece.key] ||= {})
        av = (hv[soldier.promoted] ||= [])
        av << soldier
      end

      # 消す
      def safe_delete_on(place)
        super.tap do |soldier|
          if soldier
            soldier_places_hash[soldier.location.key][soldier.piece.key].delete(soldier)
            soldier_places_hash2[soldier.location.key][soldier.piece.key][soldier.promoted].delete(soldier)
          end
        end
      end

      # 全消し
      def all_clear
        super
        soldier_places_hash.each_value(&:clear)
        soldier_places_hash2.each_value(&:clear)
      end

      def soldiers_lookup(location_key, piece_key)
        Assertion.assert { location_key.kind_of? Symbol }
        Assertion.assert { piece_key.kind_of? Symbol }

        soldier_places_hash.fetch(location_key)[piece_key] || []
      end

      def soldiers_lookup2(location_key, piece_key, promoted)
        Assertion.assert { location_key.kind_of? Symbol }
        Assertion.assert { piece_key.kind_of? Symbol }

        soldier_places_hash2.fetch(location_key).dig(piece_key, promoted) || []
      end

      private

      def soldier_places_hash
        @soldier_places_hash ||= Location.inject({}) { |a, e| a.merge(e.key => {}) }
      end

      def soldier_places_hash2
        @soldier_places_hash2 ||= Location.inject({}) { |a, e| a.merge(e.key => {}) }
      end
    end
  end
end
