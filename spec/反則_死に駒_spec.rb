require "spec_helper"

RSpec.describe "死に駒" do
  it "works" do
    sfen = "position sfen 7k1/5Gb2/7SL/8K/6s1P/9/9/9/8L b GNP 1 moves N*1a"
    info = Bioshogi::Parser.parse(sfen, typical_error_case: :embed)
    assert { info.to_kif.include?("【反則】▲１一桂は死に駒です。「▲１一桂成」の間違いかもしれません") }
    assert { Bioshogi::Parser.parse(sfen) rescue $!.class == Bioshogi::DeadPieceRuleError }
  end
end
