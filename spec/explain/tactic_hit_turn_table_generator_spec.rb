require "spec_helper"

module Bioshogi
  module Explain
    RSpec.describe TacticHitTurnTableGenerator do
      it "works" do
        TacticHitTurnTableGenerator.new.to_h(verbose: true)
      end
    end
  end
end

