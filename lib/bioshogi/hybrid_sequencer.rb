# frozen-string-literal: true

module Bioshogi
  module HybridSequencer
    def self.execute(pattern)
      if pattern[:notation_dsl]
        xcontainer = Sequencer.new
        xcontainer.pattern = pattern[:notation_dsl]
        xcontainer.evaluate
        xcontainer.snapshots
      else
        Simulator.run(pattern)
      end
    end
  end
end
