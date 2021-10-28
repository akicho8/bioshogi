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
      @hv[:header] = @parser.header.to_h

      @chess_clock = ChessClock.new

      @hv[:moves] = []
      @hv[:moves] << {
        :human_index   => @mediator2.initial_state_turn_info.display_turn,
        :place_same    => nil,
        **@chess_clock.last_clock.to_h,
        :total_seconds => nil,
        :used_seconds  => nil,
        :skill         => nil,
        :sfen_type1    => @mediator2.to_sfen,
        :sfen_type2    => @mediator2.to_snapshot_sfen,
      }
      @hv[:moves] += @parser.move_infos.collect.with_index do |info, i|
        @mediator2.execute(info[:input], used_seconds: @parser.used_seconds_at(i))
        @chess_clock.add(@parser.used_seconds_at(i))
        hand_log = @mediator2.hand_logs.last
        {
          :human_index => @mediator2.initial_state_turn_info.display_turn + i.next,
          :place_same  => hand_log.place_same,
          **hand_log.to_akf,
          **@chess_clock.last_clock.to_h,
          :skill => hand_log.skill_set.to_h,
          :sfen_type1 => @mediator2.to_sfen,
          :sfen_type2 => @mediator2.to_snapshot_sfen,
        }
      end

      @hv
    end
  end
end
# ~> -:5:in `<class:AkfBuilder>': uninitialized constant Bioshogi::AkfBuilder::Builder (NameError)
# ~> 	from -:4:in `<module:Bioshogi>'
# ~> 	from -:3:in `<main>'
