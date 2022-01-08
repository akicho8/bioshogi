# -*- compile-command: "bundle execute rspec ../../../spec/parser/parse_from_kif_format_headerr_spec.rb" -*-
# frozen-string-literal: true

module Bioshogi
  module Parser
    class Ki2Parser < Base
      include KakinokiMethods

      cattr_accessor(:line_regexp1) { /^\p{blank}*(?<turn_number>\d+)\p{blank}+(?<input>#{InputParser.regexp})(\p{blank}*\(\p{blank}*(?<clock_part>.*)\))?/o }

      class << self
        def accept?(source)
          source = Parser.source_normalize(source)
          if source.present?
            if !KifParser.accept?(source) && !CsaParser.accept?(source)
              source.match?(/^\p{blank}*(#{InputParser.regexp}|.*：.*)/) || BoardParser::KakinokiBoardParser.accept?(source)
            end
          end
        end
      end

      def parse
        kknk_header_read
        header_normalize
        kknk_board_read

        s = branch_delete(normalized_source)
        s.lines.each do |line|
          kknk_comment_read(line)
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
