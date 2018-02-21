# frozen-string-literal: true

module Warabi
  class PlayerExecutorCpu < PlayerExecutorHuman
    def turn_changed_process
      mediator.position_map[mediator.position_hash] += 1
    end
  end
end
