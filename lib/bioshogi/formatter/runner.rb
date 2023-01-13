# frozen-string-literal: true

module Bioshogi
  module Formatter
    class Runner
      attr_accessor :formatter
      attr_accessor :container

      def initialize(formatter, container)
        @formatter = formatter
        @container = container
      end

      def call
        begin
          @formatter.pi.move_infos.each.with_index do |info, i|
            if @formatter.parser_options[:debug]
              p container
            end
            if @formatter.parser_options[:callback]
              @formatter.parser_options[:callback].call(container)
            end
            if @formatter.parser_options[:turn_limit] && container.turn_info.display_turn >= @formatter.parser_options[:turn_limit]
              break
            end
            container.execute(info[:input], used_seconds: formatter.used_seconds_at(i))
          end
        rescue CommonError => error
          if v = @formatter.parser_options[:typical_error_case]
            case v
            when :embed
              @formatter.pi.error_message = error.message
            when :skip
            else
              raise MustNotHappen
            end
          else
            raise error
          end
        end
      end
    end
  end
end
