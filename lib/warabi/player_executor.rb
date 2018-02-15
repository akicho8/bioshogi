# frozen-string-literal: true

module Warabi
  class PlayerExecutor
    attr_reader :point
    attr_reader :piece
    attr_reader :point_from
    attr_reader :source
    attr_reader :player
    attr_reader :killed_soldier
    attr_reader :origin_soldier

    attr_reader :soldier
    attr_reader :direct_hand
    attr_reader :moved_hand

    include PlayerExecutorHuman

    def initialize(player, source)
      @player = player
      @source = source
    end

    def input
      @input ||= -> {
        md = InputParser.match!(@source)
        input_adapter_class(md).run(self, player, md.named_captures.symbolize_keys)
      }.call
    end

    def execute
      @candidate_soldiers = input.candidate_soldiers
      @origin_soldier     = input.origin_soldier
      @soldier            = input.soldier
      @direct_hand        = input.direct_hand
      @moved_hand         = input.moved_hand
      @killed_soldier     = nil

      if input.direct_trigger
        player.piece_box.pick_out(@soldier.piece)
        player.board.put_on(@soldier, validate: true)
      else
        @killed_soldier = player.board.lookup(@soldier.point)
        player.move_to(@origin_soldier.point, @soldier.point, input.promote_trigger)
      end
    end

    def hand_log
      @hand_log ||= HandLog.new({
          :direct_hand    => @direct_hand,
          :moved_hand     => @moved_hand,
          :candidate      => @candidate_soldiers,
          :point_same     => point_same?, # 前の手と同じかどうかは状況によって変わってしまうためこの時点でさっさと生成しておく
          :skill_set      => skill_set,
          :killed_soldier => @killed_soldier,
        }).freeze
    end

    def skill_set
      @skill_set ||= SkillSet.new
    end

    private

    def point_same?
      if hand_log = player.mediator.hand_logs.last
        hand_log.soldier.point == @soldier.point
      end
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
