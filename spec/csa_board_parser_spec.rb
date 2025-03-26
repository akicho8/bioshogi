require "spec_helper"

RSpec.describe Bioshogi::BoardParser::CsaBoardParser do
  it "基本" do
    assert { Bioshogi::Parser.parse("P2 * -HI *  *  *  *  * +KA *").to_sfen == "position sfen 9/1r5B1/9/9/9/9/9/9/9 b - 1" }
  end

  describe "空白が潰れている場合" do
    it "正しく読む" do
      assert { Bioshogi::Parser.parse("P2 * -HI * * * * * +KA *").to_sfen == "position sfen 9/1r5B1/9/9/9/9/9/9/9 b - 1" }
    end

    it "全体" do
      assert { Bioshogi::Parser.parse(<<~EOT).to_sfen == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1" }
      P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
      P2 * -HI * * * * * -KA *
      P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
      P4 * * * * * * * * *
      P5 * * * * * * * * *
      P6 * * * * * * * * *
      P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
      P8 * +KA * * * * * +HI *
      P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
      EOT
    end
  end
end
