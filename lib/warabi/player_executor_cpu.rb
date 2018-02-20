# frozen-string-literal: true

module Warabi
  class PlayerExecutorCpu < PlayerExecutorHuman
    def after_execute
      mediator.position_map[mediator.position_hash] += 1
    end
  end
end
