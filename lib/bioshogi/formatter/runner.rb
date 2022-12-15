# frozen-string-literal: true

module Bioshogi
  module Formatter
    class Runner
      attr_accessor :xparser
      attr_accessor :xcontainer

      def initialize(xparser, xcontainer)
        @xparser = xparser
        @xcontainer = xcontainer
      end

      def perform
        begin
          @xparser.mi.move_infos.each.with_index do |info, i|
            if @xparser.parser_options[:debug]
              p xcontainer
            end
            if @xparser.parser_options[:callback]
              @xparser.parser_options[:callback].call(xcontainer)
            end
            if @xparser.parser_options[:turn_limit] && xcontainer.turn_info.display_turn >= @xparser.parser_options[:turn_limit]
              break
            end
            xcontainer.execute(info[:input], used_seconds: xparser.used_seconds_at(i))
          end
        rescue CommonError => error
          if v = @xparser.parser_options[:typical_error_case]
            case v
            when :embed
              @xparser.error_message = error.message
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
