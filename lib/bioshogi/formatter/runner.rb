# frozen-string-literal: true

module Bioshogi
  module Formatter
    class Runner
      attr_accessor :exporter
      attr_accessor :xcontainer

      def initialize(exporter, xcontainer)
        @exporter = exporter
        @xcontainer = xcontainer
      end

      def perform
        begin
          @exporter.mi.move_infos.each.with_index do |info, i|
            if @exporter.parser_options[:debug]
              p xcontainer
            end
            if @exporter.parser_options[:callback]
              @exporter.parser_options[:callback].call(xcontainer)
            end
            if @exporter.parser_options[:turn_limit] && xcontainer.turn_info.display_turn >= @exporter.parser_options[:turn_limit]
              break
            end
            xcontainer.execute(info[:input], used_seconds: exporter.used_seconds_at(i))
          end
        rescue CommonError => error
          if v = @exporter.parser_options[:typical_error_case]
            case v
            when :embed
              @exporter.mi.error_message = error.message
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
