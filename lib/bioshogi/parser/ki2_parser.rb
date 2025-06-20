# frozen-string-literal: true

module Bioshogi
  module Parser
    class Ki2Parser < Base
      include KakinokiMethods

      ACCEPT_REGEXP = /^\p{blank}*(#{InputParser.regexp}|.*：.*)/
      MOVE_REGEXP   = /^\p{blank}*#{InputParser.regexp}/

      class << self
        def accept?(source)
          str = Source.wrap(source).to_s
          if str.present?
            if !KifParser.accept?(str) && !CsaParser.accept?(str)
              str.match?(ACCEPT_REGEXP) || BoardParser::KakinokiBoardParser.accept?(str)
            end
          end
        end
      end

      private

      def body_parse
        body_part.lines.each do |line|
          kknk_comment_read(line)
          if line.match?(MOVE_REGEXP)
            @pi.move_infos += InputParser.scan(line).collect do |e|
              { input: e }
            end
          end
        end

        if body_part.match?(/^まで\d+手で千日手/)
          @pi.last_action_info = LastActionInfo.fetch(:SENNICHITE)
        end
      end
    end
  end
end
