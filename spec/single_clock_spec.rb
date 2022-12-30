require "spec_helper"

module Bioshogi
  describe SingleClock do
    it "SingleClock" do
      single_clock = SingleClock.new
      single_clock.add(1)
      single_clock.add(1)
      assert { single_clock.to_s == "(00:01/00:00:02)" }
    end

    it "マイナスの時間が渡されたとき" do
      # 将棋ウォーズの棋譜取り込みで3分や10秒を10分として判別してしまったとき
      # この判定がなかったため棋譜の時間がマイナスになって他のソフトで読めなくなってしまった
      single_clock = SingleClock.new
      expect { single_clock.add(-1) }.to raise_error(TimeMinusError)
    end
  end
end
