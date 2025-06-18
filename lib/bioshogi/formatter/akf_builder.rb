# frozen-string-literal: true

module Bioshogi
  module Formatter
    class AkfBuilder
      include Builder

      def self.default_params
        super.merge({})
      end

      def initialize(formatter, params = {})
        @formatter = formatter
        @params = self.class.default_params.merge(params)
      end

      def to_h
        @formatter.container_run_once

        @container2 = Container::Basic.new
        @formatter.container_init(@container2)

        @hv = {}
        @hv[:header] = @formatter.pi.header.to_h.clone
        @hv[:header]["手数"] = @formatter.pi.move_infos.size

        @main_clock = MainClock.new

        @hv[:moves] = []
        @hv[:moves] << {
          :index         => 0,
          :human_index   => @container2.initial_state_turn_info.display_turn,
          :place_same    => nil,
          **@main_clock.last_clock.to_h,
          :total_seconds => 0,
          :used_seconds  => nil,
          :skill         => nil,
          :history_sfen  => @container2.to_history_sfen,
          :short_sfen => @container2.to_short_sfen,
        }
        @hv[:moves] += @formatter.pi.move_infos.collect.with_index do |info, i|
          @container2.execute(info[:input], used_seconds: @formatter.used_seconds_at(i))
          @main_clock.add(@formatter.used_seconds_at(i))
          hand_log = @container2.hand_logs.last
          {
            :index         => i.next,
            :human_index   => @container2.initial_state_turn_info.display_turn + i.next,
            :place_same    => hand_log.place_same,
            **hand_log.to_akf,
            **@main_clock.last_clock.to_h,
            :skill         => hand_log.tag_bundle.to_h,
            :history_sfen  => @container2.to_history_sfen,
            :short_sfen => @container2.to_short_sfen,
          }
        end

        # if @formatter.pi.last_action_params
        #   if used_seconds = @formatter.pi.last_action_params[:used_seconds]
        #     if @main_clock
        #       @main_clock.add(used_seconds)
        #       right_part = @main_clock.to_s
        #     end
        #   end
        # end

        # @hv[:header] = @hv[:header]

        if @formatter.last_action_info
          @hv[:last_action_kakinoki_word] = @formatter.last_action_info.kakinoki_word
        end

        @hv[:judgment_message]          = @formatter.judgment_message
        @hv[:error_text]                = @formatter.error_message_part

        @hv
      end
    end
  end
end
