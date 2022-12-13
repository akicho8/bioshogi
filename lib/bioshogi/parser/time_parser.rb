module Bioshogi
  module Parser
    class TimeParser
      def initialize(time_str)
        @time_str = time_str
      end

      def to_time
        case_a || case_b
      end

      private

      def case_a
        Time.parse(@time_str) rescue nil
      end

      def case_b
        values = @time_str.scan(/\d+/).collect(&:to_i)
        Time.local(*values) rescue nil
      end
    end
  end
end
