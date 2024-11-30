# frozen-string-literal: true
#
# 駒柱判定用
#
module Bioshogi
  module Analysis
    module BoardPillerMethods
      def place_on(soldier, options = {})
        super
        piller_cop.set(soldier.place)
      end

      def safe_delete_on(*)
        super.tap do |soldier|
          if soldier
            piller_cop.remove(soldier.place)
          end
        end
      end

      def all_clear
        super
        piller_cop.reset
      end

      def piller_cop
        @piller_cop ||= PillerCop.new
      end
    end
  end
end
