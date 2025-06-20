# frozen-string-literal: true

module Bioshogi
  module Parser
    class KifParser < Base
      include KakinokiMethods

      TURN_REGEXP    = /^\p{blank}*(?<turn_number>\d+)\p{blank}+/ # 後ろにスペースを含むこと
      TIME_REGEXP    = /\p{blank}*(\(\p{blank}*(?<clock_part>.*)\))/
      MOVE_REGEXP    = /#{TURN_REGEXP}(?<input>#{InputParser.regexp})#{TIME_REGEXP}?/o
      LAST1_REGEXP   = /#{TURN_REGEXP}(?<last_action_key>.+)#{TIME_REGEXP}/o
      LAST2_REGEXP   = /#{TURN_REGEXP}(?<last_action_key>.+)/o
      LAST_REGEXP    = Regexp.union(LAST1_REGEXP, LAST2_REGEXP)
      MIN_SEC_REGEXP = /(?<min>\d+):(?<sec>\d+)/

      class << self
        def accept?(source)
          str = Source.wrap(source).to_s
          str.match?(HEADER_BODY_SEP_REGEXP) || str.match?(MOVE_REGEXP) || str.match?(LAST_REGEXP)
        end
      end

      private

      def body_parse
        body_part.lines.each do |line|
          kknk_comment_read(line)
          case
          when md = line.match(MOVE_REGEXP)
            input = md[:input].remove(/\p{blank}/)
            used_seconds = min_sec_str_to_seconds(md[:clock_part])
            @pi.move_infos << {
              :turn_number  => md[:turn_number],
              :input        => input,
              :clock_part   => md[:clock_part],
              :used_seconds => used_seconds,
            }
          when md = line.match(LAST_REGEXP)
            @pi.final_result.last_action_key   = md[:last_action_key].strip.presence
            @pi.last_used_seconds = min_sec_str_to_seconds(md[:clock_part])
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
