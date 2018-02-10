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
        mediator = SimulatorFrame.new(pattern)
        # mediator.build_frames{|e|p e}
        mediator.build_frames
      end
    end
  end
end
