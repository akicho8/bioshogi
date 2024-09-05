require "spec_helper"

module Bioshogi
  RSpec.describe BoardParser::CsaBoardParser do
    it "基本" do
      assert { Parser.parse("P2 * -HI *  *  *  *  * +KA *").to_sfen == "position sfen 9/1r5B1/9/9/9/9/9/9/9 b - 1" }
    end

    describe "空白が潰れている場合" do
      it "正しく読む" do
        assert { Parser.parse("P2 * -HI * * * * * +KA *").to_sfen == "position sfen 9/1r5B1/9/9/9/9/9/9/9 b - 1" }
      end

      it "全体" do
        assert { Parser.parse(<<~EOT).to_sfen == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1" }
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
end
# >> Coverage report generated for RSpec to /Users/ikeda/src/bioshogi/coverage. 7 / 15 LOC (46.67%) covered.
# >> ...
# >> 
# >> Top 3 slowest examples (0.03483 seconds, 87.8% of total time):
# >>   Bioshogi::BoardParser::CsaBoardParser 空白が潰れている場合 全体
# >>     0.01832 seconds -:15
# >>   Bioshogi::BoardParser::CsaBoardParser 基本
# >>     0.01282 seconds -:5
# >>   Bioshogi::BoardParser::CsaBoardParser 空白が潰れている場合 正しく読む
# >>     0.00369 seconds -:10
# >> 
# >> Finished in 0.03968 seconds (files took 1.61 seconds to load)
# >> 3 examples, 0 failures
# >> 
