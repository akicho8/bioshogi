# frozen-string-literal: true

module Bioshogi
  module Analysis
    class OverallSkillDetector
      attr_accessor :xparser
      attr_accessor :container

      def initialize(xparser, container)
        @xparser = xparser
        @container = container
      end

      def call
        OverallSkillInfo.each do |e|
          if v = e.turn_gteq
            unless @container.turn_info.turn_offset >= v
              next
            end
          end
          if v = e.only_preset_attr
            unless @xparser.preset_info_or_nil&.public_send(v)
              next
            end
          end
          if e.critical
            unless @container.critical_turn
              next
            end
          end
          if e.outbreak
            unless @container.outbreak_turn
              next
            end
          end
          if e.checkmate
            unless @xparser.pi.last_checkmate_p
              next
            end
          end
          instance_exec(&e.func)
        end
      end

      # 勝った側を返す
      # nil の場合もある
      def win_side_location
        @win_side_location ||= @xparser.win_side_location(@container)
      end
    end
  end
end
