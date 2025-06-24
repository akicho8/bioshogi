# frozen-string-literal: true

#
# 駒柱判定用
#
module Bioshogi
  module Analysis
    module ColumnSoldierCounterMethods
      def place_on(soldier, options = {})
        super
        column_soldier_counter.set(soldier.place)
      end

      def safe_delete_on(*)
        super.tap do |soldier|
          if soldier
            column_soldier_counter.remove(soldier.place)
          end
        end
      end

      def all_clear
        super
        column_soldier_counter.reset
      end

      def column_soldier_counter
        @column_soldier_counter ||= ColumnSoldierCounter.new
      end
    end
  end
end
