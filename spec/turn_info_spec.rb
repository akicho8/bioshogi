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
      turn_info.base_counter = 2
      turn_info.counter = 3
      assert { turn_info.display_turn == 5 }
      assert { turn_info.order_info.key == :gote }
    end
  end
end
