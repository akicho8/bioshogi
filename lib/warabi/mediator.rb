# frozen-string-literal: true

module Warabi
  class Mediator
    include MediatorBase
    include MediatorPlayers
    include MediatorSerializers
    include MediatorExecutor
    include MediatorVariables
    include MediatorTest
    include MediatorMemento

    attr_writer :kill_counter

    delegate :to_kif_a, :to_ki2_a, :to_kif_oneline, to: :hand_logs

    def kill_counter
      @kill_counter ||= 0
    end

    def hand_logs
      @hand_logs ||= HandLogs.new([])
    end
  end
end
