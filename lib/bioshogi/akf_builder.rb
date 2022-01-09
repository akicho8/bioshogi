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
      @parser.mediator_run_once

      @mediator2 = Mediator.new
      @parser.mediator_board_setup(@mediator2)

      @hv = {}
      @hv[:header] = @parser.header.to_h.clone
      @hv[:header]["手数"] = @parser.move_infos.size

      @chess_clock = ChessClock.new

      @hv[:moves] = []
      @hv[:moves] << {
        :index         => 0,
        :human_index   => @mediator2.initial_state_turn_info.display_turn,
        :place_same    => nil,
        **@chess_clock.last_clock.to_h,
        :total_seconds => 0,
        :used_seconds  => nil,
        :skill         => nil,
        :history_sfen  => @mediator2.to_history_sfen,
        :snapshot_sfen => @mediator2.to_snapshot_sfen,
      }
      @hv[:moves] += @parser.move_infos.collect.with_index do |info, i|
        @mediator2.execute(info[:input], used_seconds: @parser.used_seconds_at(i))
        @chess_clock.add(@parser.used_seconds_at(i))
        hand_log = @mediator2.hand_logs.last
        {
          :index         => i.next,
          :human_index   => @mediator2.initial_state_turn_info.display_turn + i.next,
          :place_same    => hand_log.place_same,
          **hand_log.to_akf,
          **@chess_clock.last_clock.to_h,
          :skill         => hand_log.skill_set.to_h,
          :history_sfen  => @mediator2.to_history_sfen,
          :snapshot_sfen => @mediator2.to_snapshot_sfen,
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

      @hv[:header] = @hv[:header].merge({
          :last_action_kif_word => @parser.last_action_info.kif_word,
          :judgment_message     => @parser.judgment_message,
          :error_text           => @parser.error_message_part,
        })

      @hv
    end
  end
end
