require_relative "spec_helper"

module Bushido
  describe TurnInfo do
    it "駒落ちなので△から始まる" do
      turn_info = TurnInfo.new("香車落ち")
      turn_info.current_location.key == :white
    end

    it "平手なので▲から始まる" do
      turn_info = TurnInfo.new("平手")
      turn_info.current_location.key == :black
    end
  end
end
