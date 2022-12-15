# frozen-string-literal: true

module Bioshogi
  class AkfBuilder
    include Builder

    def self.default_params
      super.merge({
        })
    end

    def initialize(parser, params = {})
      @parser = parser
      @params = self.class.default_params.merge(params)
    end

    def to_h
      @parser.xcontainer_run_once

      @xcontainer2 = Xcontainer.new
      @parser.xcontainer_board_setup(@xcontainer2)

      @hv = {}
      @hv[:header] = @parser.header.to_h.clone
      @hv[:header]["手数"] = @parser.mi.move_infos.size

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
      @hv[:moves] += @parser.mi.move_infos.collect.with_index do |info, i|
        @xcontainer2.execute(info[:input], used_seconds: @parser.used_seconds_at(i))
        @chess_clock.add(@parser.used_seconds_at(i))
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

      # if @parser.last_action_params
      #   if used_seconds = @parser.last_action_params[:used_seconds]
      #     if @chess_clock
      #       @chess_clock.add(used_seconds)
      #       right_part = @chess_clock.to_s
      #     end
      #   end
      # end

      @hv[:header] = @hv[:header]

      if @parser.last_action_info
        @hv[:last_action_kakinoki_word] = @parser.last_action_info.kakinoki_word
      end

      @hv[:judgment_message]          = @parser.judgment_message
      @hv[:error_text]                = @parser.error_message_part

      @hv
    end
  end
end
