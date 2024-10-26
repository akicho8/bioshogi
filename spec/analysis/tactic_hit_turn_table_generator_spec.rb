require "spec_helper"

module Bioshogi
  module Analysis
    describe "発動手数のテーブル生成", tactic: true do
      it "works" do
        assert { TacticHitTurnTableGenerator.new.to_h }
      end
    end
  end
end

