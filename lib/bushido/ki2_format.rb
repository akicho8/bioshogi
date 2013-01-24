# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/ki2_format_spec.rb" -*-

module Bushido
  module Ki2Format
    class Parser < BaseFormat::Parser
      def self.resolved?(source)
        source = normalized_source(source)
        !source.match(/^手数.*指手.*消費時間.*$/) && source.match(/\n\n/)
      end

      def parse
        @_head, @_body = @source.split(/\n\n/, 2)
        read_header
        @_body.lines.each do |line|
          comment_read(line)
          if line.match(/^\s*[▲△]/)
            @move_infos += line.scan(/[▲△]([^▲△\s]+)/).flatten.collect{|input|{:input => input}}
          end
        end
      end
    end
  end
end
