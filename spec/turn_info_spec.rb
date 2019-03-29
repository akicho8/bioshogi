require_relative "spec_helper"

module Bioshogi
  describe TurnInfo do
    it "駒落ちなので△から始まる" do
      turn_info = TurnInfo.new(handicap: true)
      assert { turn_info.current_location.key == :white }
    end

    it "平手なので▲から始まる" do
      turn_info = TurnInfo.new
      assert { turn_info.current_location.key == :black }
    end
  end
end
