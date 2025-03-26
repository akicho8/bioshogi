require "spec_helper"

RSpec.describe "二歩" do
  it "works" do
    sfen = "position sfen 4k4/9/4p4/9/9/9/4P4/9/4K4 b P 1 moves 5g5f 5c5d P*5e"
    assert { Bioshogi::Parser.parse(sfen).to_sfen rescue $!.class == Bioshogi::DoublePawnCommonError }
    assert { Bioshogi::Parser.parse(sfen, validate_double_pawn_skip: true).to_sfen == sfen }
  end
end
