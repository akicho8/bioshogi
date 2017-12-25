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
          s = /\p{blank}*/
          i = Runner.input_regexp
          if line.match?(/^#{s}#{i}/o)
            line.scan(i) do |parts|
              @move_infos << {input: parts.join}
            end
          end
        end

        # *引き分け
        # まで59手で千日手

        # *二歩の反則
        # まで88手で先手の反則勝ち

        if normalized_source.match?(/^まで\d+手で千日手/)
          @last_status_params = {last_action_key: "SENNICHITE"}
        end
      end
    end
  end
end
