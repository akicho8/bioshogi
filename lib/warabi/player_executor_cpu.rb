# frozen-string-literal: true

module Warabi
  class PlayerExecutorCpu < PlayerExecutorHuman
    def turn_changed_process
      mediator.one_place_map[mediator.one_place_hash] += 1
    end
  end
end
