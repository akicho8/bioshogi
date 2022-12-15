# frozen-string-literal: true

module Bioshogi
  module Formatter
    class Exporter
      attr_accessor :mi
      attr_accessor :parser_options

      def initialize(mi, parser_options)
        @mi = mi
        @parser_options = parser_options
      end

      def to_kif(options = {})
        KifBuilder.new(self, options).to_s
      end
    end
  end
end
