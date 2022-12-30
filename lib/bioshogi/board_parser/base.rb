# frozen-string-literal: true

module Bioshogi
  module BoardParser
    class Base
      class << self
        def accept?
          raise NotImplementedError, "#{__method__} is not implemented"
        end

        def parse(source, options = {})
          new(source, options).tap(&:parse)
        end
      end

      def initialize(source, options = {})
        @source = source
        @options = options
      end

      delegate *[
        :sorted_soldiers,
        :location_split,
        :place_as_key_table,
        :location_adjust,
      ], to: :soldiers

      def soldiers
        soldier_box
      end

      def soldier_box
        @soldier_box ||= SoldierBox.new
      end

      private

      def shape_lines
        @shape_lines ||= Source.wrap(@source).to_s.remove(/\s*#.*/).strip.lines.to_a
      end
    end
  end
end
