# frozen-string-literal: true

module Bioshogi
  module BoardParser
    class << self
      def accept?(source)
        !!parser_class_find(source)
      end

      def parse(source, options = {})
        parser = parser_class_find(source)
        unless parser
          raise FileFormatError, "盤面のフォーマットが不明です : #{source}"
        end
        parser.parse(source, options)
      end

      private

      def parser_class_find(source)
        support_parsers.find {|e| e.accept?(source) }
      end

      def support_parsers
        [
          KakinokiBoardParser,
          CsaBoardParser,
          SfenBoardParser,
        ]
      end
    end
  end
end
