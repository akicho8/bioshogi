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

    it "display_turn" do
      turn_info = TurnInfo.new
      turn_info.turn_base = 2
      turn_info.turn_offset = 3
      assert { turn_info.display_turn == 5 }
    end

    it "turn_offset_zero_location" do
      assert { TurnInfo.new(handicap: true,  turn_base: 0, turn_offset: 1).turn_offset_zero_location.key == :white }
      assert { TurnInfo.new(handicap: false, turn_base: 0, turn_offset: 1).turn_offset_zero_location.key == :black }
      assert { TurnInfo.new(handicap: true,  turn_base: 1, turn_offset: 1).turn_offset_zero_location.key == :black }
      assert { TurnInfo.new(handicap: false, turn_base: 1, turn_offset: 1).turn_offset_zero_location.key == :white }
    end
  end
end
