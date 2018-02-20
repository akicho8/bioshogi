# frozen-string-literal: true

module Warabi
  class PlayerExecutorBase
    attr_reader :player
    attr_reader :source
    attr_reader :params

    attr_reader :point
    attr_reader :piece
    attr_reader :point_from
    attr_reader :killed_soldier
    attr_reader :origin_soldier

    attr_reader :soldier
    attr_reader :direct_hand
    attr_reader :move_hand

    delegate :board, :piece_box, :mediator, to: :player

    def initialize(player, source, **params)
      @player = player
      @source = source
      @params = {}.merge(params)
    end

    def input
      @input ||= -> {
        md = InputParser.match!(@source)
        input_adapter_class(md).new(player, md.named_captures.symbolize_keys)
      }.call
    end

    def execute
      input.perform_validations
      if error = input.errors.first
        raise_error(error)
      end

      @candidate_soldiers = input.candidate_soldiers
      @origin_soldier     = input.origin_soldier
      @soldier            = input.soldier
      @direct_hand        = input.direct_hand
      @move_hand          = input.move_hand
      @killed_soldier     = nil

      if input.direct_trigger
        piece_box.pick_out(@soldier.piece)
        board.put_on(@soldier)
      else
        @killed_soldier = board.lookup(@soldier.point)
        if @killed_soldier
          board.pick_up(@soldier.point)
          piece_box.add(@killed_soldier.piece.key => 1)
          kill_counter_inc
        end
        board.pick_up(@move_hand.origin_soldier.point)
        board.put_on(@move_hand.soldier, validate: true)
      end

      perform_skill_monitor

      hand_push
      mediator.turn_info.counter += 1

      after_execute
    end

    def kill_counter_inc
    end

    def hand_push
    end

    def perform_skill_monitor
    end

    def after_execute
    end

    private

    def raise_error(error)
      attributes = {
        "手番"   => player.call_name,
        "指し手" => input.input.values.join,
        "棋譜"   => mediator.hand_logs.to_kif_a.join(" "),
      }

      str = [error[:message]]
      str.concat(attributes.collect { |*e| e.join(": ") })
      str << mediator.to_bod
      str = str.join("\n")

      raise error[:error_class].new(str)
    end

    def input_adapter_class(md)
      case
      when md[:kif_point_from]
        InputAdapter::KifAdapter
      when md[:usi_to]
        InputAdapter::UsiAdapter
      when md[:csa_piece]
        InputAdapter::CsaAdapter
      else
        InputAdapter::Ki2Adapter
      end
    end
  end
end
