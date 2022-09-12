require "spec_helper"

module Bioshogi
  describe "usi" do
    it "出力" do
      xcontainer = Xcontainer.new
      xcontainer.placement_from_preset("平手")
      xcontainer.before_run_process
      assert { xcontainer.to_history_sfen(startpos_embed: true) == "position startpos" }
      assert { xcontainer.to_history_sfen == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1" }
      assert { xcontainer.to_short_sfen == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1" }
      xcontainer.pieces_set("▲銀△銀銀")
      # puts xcontainer
      assert { xcontainer.board.to_sfen == "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL" }
      assert { xcontainer.to_history_sfen(startpos_embed: true) == "position startpos" }
      xcontainer.execute("▲６八銀")
      assert { xcontainer.hand_logs.last.to_sfen == "7i6h" }
      assert { xcontainer.to_history_sfen(startpos_embed: true) == "position startpos moves 7i6h" }
      xcontainer.execute("△２四銀打")
      assert { xcontainer.hand_logs.last.to_sfen == "S*2d" }
      assert { xcontainer.to_history_sfen(startpos_embed: true) == "position startpos moves 7i6h S*2d" }
      assert { xcontainer.initial_state_board_sfen == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1" }
      # puts xcontainer.board
      assert { xcontainer.to_history_sfen(startpos_embed: true) == "position startpos moves 7i6h S*2d" }
    end

    it "入力" do
      usi = SfenFacade::SetupFromSource.new
      usi.execute("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d")
      assert { usi.xcontainer.to_history_sfen == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d" }
      usi.execute("position startpos moves 7i6h")
      assert { usi.xcontainer.to_history_sfen(startpos_embed: true) == "position startpos moves 7i6h" }
      usi.execute("position startpos")
      assert { usi.xcontainer.to_history_sfen(startpos_embed: true) ==  "position startpos" }
      usi.execute("position sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1")
      assert { usi.xcontainer.to_history_sfen == "position sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1" }
    end
  end
end
# >> Coverage report generated for RSpec to /Users/ikeda/src/bioshogi/coverage. 7 / 15 LOC (46.67%) covered.
# >> ..
# >> 
# >> Top 2 slowest examples (0.02496 seconds, 82.9% of total time):
# >>   usi 出力
# >>     0.01726 seconds -:5
# >>   usi 入力
# >>     0.0077 seconds -:27
# >> 
# >> Finished in 0.03009 seconds (files took 1.43 seconds to load)
# >> 2 examples, 0 failures
# >> 
