# frozen-string-literal: true
module Bioshogi
  module Parser
    class KifParser < Base
      include KakinokiMethods

      BEFORE_REGEXP  = /^\p{blank}*(?<turn_number>\d+)\p{blank}+/
      MOVE_REGEXP    = /#{BEFORE_REGEXP}(?<input>#{InputParser.regexp})(\p{blank}*\(\p{blank}*(?<clock_part>.*)\))?/o
      LAST_REGEXP    = /#{BEFORE_REGEXP}(?<last_action_key>\S+)(\p{blank}*\(\p{blank}*(?<clock_part>.*)\))?/o
      MIN_SEC_REGEXP = /(?<min>\d+):(?<sec>\d+)/

      class << self
        def accept?(source)
          source = Parser.source_normalize(source)
          source.match?(HEADER_BODY_SEP_REGEXP) || source.match?(MOVE_REGEXP) || source.match?(LAST_REGEXP)
        end
      end

      private

      def body_parse
        body_part.lines.each do |line|
          kknk_comment_read(line)
          if md = line.match(MOVE_REGEXP)
            input = md[:input].remove(/\p{blank}/)
            used_seconds = min_sec_str_to_seconds(md[:clock_part])
            @move_infos << {
              :turn_number  => md[:turn_number],
              :input        => input,
              :clock_part   => md[:clock_part],
              :used_seconds => used_seconds,
            }
          else
            if md = line.match(LAST_REGEXP)
              used_seconds = min_sec_str_to_seconds(md[:clock_part])
              @last_action_params = {
                :turn_number     => md[:turn_number],
                :last_action_key => md[:last_action_key],
                :used_seconds    => used_seconds,
              }
            end
          end
        end
      end

      def min_sec_str_to_seconds(s)
        if s.present?
          if md = s.match(MIN_SEC_REGEXP)
            md[:min].to_i.minutes + md[:sec].to_i.seconds
          end
        end
      end
    end
  end
end
