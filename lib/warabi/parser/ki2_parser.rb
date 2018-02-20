# -*- compile-command: "bundle execute rspec ../../../spec/parser/parse_from_kif_format_headerr_spec.rb" -*-
# frozen-string-literal: true

module Warabi
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
          i = InputParser.regexp
          if line.match?(/^#{s}#{i}/o)
            @move_infos += InputParser.scan(line).collect { |e| {input: e} }
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
