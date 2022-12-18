# frozen-string-literal: true

module Bioshogi
  module HybridSequencer
    def self.execute(pattern)
      if pattern[:notation_dsl]
        container = Sequencer.new
        container.pattern = pattern[:notation_dsl]
        container.evaluate
        container.snapshots
      else
        Simulator.run(pattern)
      end
    end
  end
end
