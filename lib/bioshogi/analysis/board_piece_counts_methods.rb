# frozen-string-literal: true

#
# 盤上の駒数を素早く得るための仕組み
#

module Bioshogi
  module Analysis
    module BoardPieceCountsMethods
      def place_on(soldier, options = {})
        super
        soldiers_count[soldier.location.key].increment(soldier.piece.key)
        soldiers_count_per_location.increment(soldier.location.key)
      end

      def safe_delete_on(place)
        super.tap do |soldier|
          if soldier
            soldiers_count[soldier.location.key].decrement(soldier.piece.key)
            soldiers_count_per_location.decrement(soldier.location.key)
          end
        end
      end

      def all_clear
        super
        soldiers_count.each_value(&:clear)
        soldiers_count_per_location.clear
      end

      ################################################################################ 「大駒コンプリート」「金銀コンプリート」チェック用

      # 「先後と駒」をキーにして駒数を得る
      def soldiers_count
        @soldiers_count ||= Location.inject({}) { |a, e| a.merge(e.key => CounterHash.new) }
      end

      ################################################################################ 「全駒」チェック用

      # 「先後」をキーにして駒数を得る
      def soldiers_count_per_location
        @soldiers_count_per_location ||= CounterHash.new
      end

      ################################################################################
    end
  end
end
