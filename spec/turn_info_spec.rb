require "spec_helper"

RSpec.describe Bioshogi::TurnInfo do
  it "1手づつ先後が変化する" do
    turn_info = Bioshogi::TurnInfo.new
    assert { turn_info.current_location.key == :black }
    turn_info.turn_offset += 1
    assert { turn_info.current_location.key == :white }
  end

  it "駒落ちなら△から始まる" do
    assert { Bioshogi::TurnInfo.new(handicap: false).current_location.key == :black }
    assert { Bioshogi::TurnInfo.new(handicap: true).current_location.key == :white  }
  end

  it "内部で何手目か始まったを持っているのでオフセット2でも表示は変わる。また駒落ちかどうかには関係がない" do
    assert { Bioshogi::TurnInfo.new(handicap: false, turn_base: 2, turn_offset: 3).display_turn == 5 }
    assert { Bioshogi::TurnInfo.new(handicap: true,  turn_base: 2, turn_offset: 3).display_turn == 5 }
  end

  it "1手も動かしてない状態の手番を返す(turn_offsetは無視する)" do
    assert { Bioshogi::TurnInfo.new(handicap: true,  turn_base: 0, turn_offset: 1).turn_offset_zero_location.key == :white }
    assert { Bioshogi::TurnInfo.new(handicap: false, turn_base: 0, turn_offset: 1).turn_offset_zero_location.key == :black }
    assert { Bioshogi::TurnInfo.new(handicap: true,  turn_base: 1, turn_offset: 1).turn_offset_zero_location.key == :black }
    assert { Bioshogi::TurnInfo.new(handicap: false, turn_base: 1, turn_offset: 1).turn_offset_zero_location.key == :white }
  end
end
