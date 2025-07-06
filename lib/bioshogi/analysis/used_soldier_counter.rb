# frozen-string-literal: true

module Bioshogi
  module Analysis
    class UsedSoldierCounter
      delegate :[], :to_h, to: :counts

      def initialize
        @counts = Hash.new(0)
      end

      def update(soldier)
        counts[soldier.to_counts_key] += 1
      end

      def to_s
        av = FreqPieceInfo.values
        if false
          av = av.sort_by { |e| -counts[e.to_counts_key] }
        else
          av = av.reverse
        end
        av.collect { |e|
          [e.name, counts[e.to_counts_key]].join
        }.join(" ")
      end

      private

      attr_reader :counts
    end
  end
end
