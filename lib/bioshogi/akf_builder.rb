# frozen-string-literal: true

module Bioshogi
  class AkfBuilder
    include Builder

    def self.default_params
      super.merge({
        })
    end

    def initialize(exporter, params = {})
      @exporter = exporter
      @params = self.class.default_params.merge(params)
    end

    def to_h
      @exporter.xcontainer_run_once

      @xcontainer2 = Xcontainer.new
      @exporter.xcontainer_init(@xcontainer2)

      @hv = {}
      @hv[:header] = @exporter.mi.header.to_h.clone
      @hv[:header]["手数"] = @exporter.mi.move_infos.size

      @chess_clock = ChessClock.new

      @hv[:moves] = []
      @hv[:moves] << {
        :index         => 0,
        :human_index   => @xcontainer2.initial_state_turn_info.display_turn,
        :place_same    => nil,
        **@chess_clock.last_clock.to_h,
        :total_seconds => 0,
        :used_seconds  => nil,
        :skill         => nil,
        :history_sfen  => @xcontainer2.to_history_sfen,
        :short_sfen => @xcontainer2.to_short_sfen,
      }
      @hv[:moves] += @exporter.mi.move_infos.collect.with_index do |info, i|
        @xcontainer2.execute(info[:input], used_seconds: @exporter.used_seconds_at(i))
        @chess_clock.add(@exporter.used_seconds_at(i))
        hand_log = @xcontainer2.hand_logs.last
        {
          :index         => i.next,
          :human_index   => @xcontainer2.initial_state_turn_info.display_turn + i.next,
          :place_same    => hand_log.place_same,
          **hand_log.to_akf,
          **@chess_clock.last_clock.to_h,
          :skill         => hand_log.skill_set.to_h,
          :history_sfen  => @xcontainer2.to_history_sfen,
          :short_sfen => @xcontainer2.to_short_sfen,
        }
      end

      # if @exporter.mi.last_action_params
      #   if used_seconds = @exporter.mi.last_action_params[:used_seconds]
      #     if @chess_clock
      #       @chess_clock.add(used_seconds)
      #       right_part = @chess_clock.to_s
      #     end
      #   end
      # end

      @hv[:header] = @hv[:header]

      if @exporter.last_action_info
        @hv[:last_action_kakinoki_word] = @exporter.last_action_info.kakinoki_word
      end

      @hv[:judgment_message]          = @exporter.judgment_message
      @hv[:error_text]                = @exporter.error_message_part

      @hv
    end
  end
end
