require_relative "spec_helper"

module Bioshogi
  describe ChessClock do
    it "ChessClock" do
      chess_clock = ChessClock.new
      chess_clock.add(1)
      chess_clock.add(5)
      chess_clock.add(1)
      assert { chess_clock.to_s == "(00:01/00:00:02)" }
    end

    it "PersonalClock" do
      personal_clock = ChessClock::PersonalClock.new
      personal_clock.add(1)
      personal_clock.add(1)
      assert { personal_clock.to_s == "(00:01/00:00:02)" }
    end

    it "マイナスの時間が渡されたとき" do
      # 将棋ウォーズの棋譜取り込みで3分や10秒を10分として判別してしまったとき
      # この判定がなかったため棋譜の時間がマイナスになって他のソフトで読めなくなってしまった
      personal_clock = ChessClock::PersonalClock.new
      expect { personal_clock.add(-1) }.to raise_error(TimeMinusError)
    end
  end
end
