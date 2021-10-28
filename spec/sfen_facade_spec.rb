require "spec_helper"

module Bioshogi
  describe "usi" do
    it "出力" do
      mediator = Mediator.new
      mediator.placement_from_preset("平手")
      mediator.before_run_process
      assert { mediator.to_history_sfen(startpos_embed: true) == "position startpos" }
      assert { mediator.to_history_sfen == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1" }
      assert { mediator.to_snapshot_sfen == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1" }
      mediator.pieces_set("▲銀△銀銀")
      # puts mediator
      assert { mediator.board.to_sfen == "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL" }
      assert { mediator.to_history_sfen(startpos_embed: true) == "position startpos" }
      mediator.execute("▲６八銀")
      assert { mediator.hand_logs.last.to_sfen == "7i6h" }
      assert { mediator.to_history_sfen(startpos_embed: true) == "position startpos moves 7i6h" }
      mediator.execute("△２四銀打")
      assert { mediator.hand_logs.last.to_sfen == "S*2d" }
      assert { mediator.to_history_sfen(startpos_embed: true) == "position startpos moves 7i6h S*2d" }
      assert { mediator.initial_state_board_sfen == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1" }
      # puts mediator.board
      assert { mediator.to_history_sfen(startpos_embed: true) == "position startpos moves 7i6h S*2d" }
    end

    it "入力" do
      usi = SfenFacade::SetupFromSource.new
      usi.execute("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d")
      assert { usi.mediator.to_history_sfen == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d" }
      usi.execute("position startpos moves 7i6h")
      assert { usi.mediator.to_history_sfen(startpos_embed: true) == "position startpos moves 7i6h" }
      usi.execute("position startpos")
      assert { usi.mediator.to_history_sfen(startpos_embed: true) ==  "position startpos" }
      usi.execute("position sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1")
      assert { usi.mediator.to_history_sfen == "position sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1" }
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
