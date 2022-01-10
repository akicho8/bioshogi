# frozen-string-literal: true
module Bioshogi
  module Parser
    class Ki2Parser < Base
      include KakinokiMethods

      ACCEPT_REGEXP = /^\p{blank}*(#{InputParser.regexp}|.*：.*)/o
      MOVE_REGEXP   = /^\p{blank}*#{InputParser.regexp}/o

      class << self
        def accept?(source)
          source = Parser.source_normalize(source)
          if source.present?
            if !KifParser.accept?(source) && !CsaParser.accept?(source)
              source.match?(ACCEPT_REGEXP) || BoardParser::KakinokiBoardParser.accept?(source)
            end
          end
        end
      end

      private

      def body_parse
        body_part.lines.each do |line|
          kknk_comment_read(line)
          if line.match?(MOVE_REGEXP)
            @move_infos += InputParser.scan(line).collect do |e|
              { input: e }
            end
          end
        end

        if body_part.match?(/^まで\d+手で千日手/)
          @last_action_params = { last_action_key: "SENNICHITE" }
        end
      end
    end
  end
end
