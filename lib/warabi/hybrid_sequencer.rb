# frozen-string-literal: true

module Warabi
  module HybridSequencer
    def self.execute(pattern)
      if pattern[:dsl]
        mediator = Sequencer.new
        mediator.pattern = pattern[:dsl]
        mediator.evaluate
        mediator.snapshots
      else
        Simulator.run(pattern)
      end
    end
  end
end
