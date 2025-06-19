# frozen-string-literal: true

module Bioshogi
  module Formatter
    class TagEmbed
      attr_accessor :xparser
      attr_accessor :container

      def initialize(xparser, container)
        @xparser = xparser
        @container = container
      end

      def call
        Analysis::OverallTagDetector.new(@container).call
        header_write
      end

      private

      def header_write
        Analysis::TacticInfo.each do |e|
          @container.players.each do |player|
            list = player.tag_bundle.value(e).normalize
            if v = list.presence
              v = v.uniq # 手筋の場合、複数になる場合があるので uniq する
              key = "#{player.call_name}の#{e.name}"
              @xparser.tag_set_hash[key] = v.collect(&:name)
            end
          end
        end
        hv = @xparser.tag_set_hash.transform_values { |e| e.join(", ") }
        @xparser.pi.header.object.update(hv)
      end
    end
  end
end
