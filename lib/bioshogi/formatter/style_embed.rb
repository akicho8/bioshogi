# frozen-string-literal: true

module Bioshogi
  module Formatter
    class StyleEmbed
      attr_accessor :xparser
      attr_accessor :container

      def initialize(xparser, container)
        @xparser = xparser
        @container = container
      end

      def call
        if @xparser.preset_info
          if @xparser.preset_info.hirate_like
            @container.players.each do |player|
              if main_style_info = player.skill_set.main_style_info
                @xparser.pi.header.object.update("#{player.call_name}の棋風" => main_style_info.name)
              end
            end
          end
        end
      end
    end
  end
end
