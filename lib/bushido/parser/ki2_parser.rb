# -*- compile-command: "bundle exec rspec ../../../spec/parser/ki2_parser_spec.rb" -*-
# frozen-string-literal: true

module Bushido
  module Parser
    class Ki2Parser < Base
      class << self
        def accept?(source)
          !KifParser.accept?(source) && !CsaParser.accept?(source)
        end
      end

      def parse
        header_read
        header_normalize
        board_read

        normalized_source.lines.each do |line|
          comment_read(line)
          if line.match?(/^\p{blank}*[#{Location.triangles}]?\p{blank}*#{Runner.input_regexp}/o)
            line.scan(Runner.input_regexp).each do |parts|
              @move_infos << {input: parts.join}
            end
          end
        end
      end
    end
  end
end
