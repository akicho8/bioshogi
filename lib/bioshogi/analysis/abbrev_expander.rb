# frozen-string-literal: true

module Bioshogi
  module Analysis
    class AbbrevExpander
      SUFFIX_LIST = ["戦法", "囲い", "流", "型"]

      attr_reader :str

      class << self
        def expand(...)
          new(...).call
        end
      end

      def initialize(str)
        @str = str.strip
      end

      def call
        if @str.blank?
          return []
        end

        # 順番重要
        [
          str,
          *correct_notational_variation,
          *SUFFIX_LIST.collect { |e| "#{strip_str}#{e}" },
          strip_str,
        ].compact_blank.uniq
      end

      private

      def correct_notational_variation
        [
          str.sub(/向かい飛車/, "向飛車"),
          str.sub(/向飛車/, "向かい飛車"),
        ]
      end

      def strip_str
        @strip_str ||= str.remove(/(#{SUFFIX_LIST.join("|")})\z/)
      end
    end
  end
end
