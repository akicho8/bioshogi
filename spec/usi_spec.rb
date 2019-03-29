require_relative "spec_helper"

module Bioshogi
  describe "usi" do
    it "usi (sfen) 形式で出力" do
      mediator = Mediator.new
      mediator.placement_from_preset("平手")
      mediator.before_run_process
      assert { mediator.to_sfen == "position startpos" }
      assert { mediator.to_long_sfen == "sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1" }
      mediator.pieces_set("▲銀△銀銀")
      # puts mediator
      assert { mediator.board.to_sfen == "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL" }
      assert { mediator.to_sfen == "position startpos" }
      mediator.execute("▲６八銀")
      assert { mediator.hand_logs.last.to_sfen == "7i6h" }
      assert { mediator.to_sfen == "position startpos moves 7i6h" }
      mediator.execute("△２四銀打")
      assert { mediator.hand_logs.last.to_sfen == "S*2d" }
      assert { mediator.to_sfen == "position startpos moves 7i6h S*2d" }
      assert { mediator.initial_state_board_sfen == "startpos" }
      # puts mediator.board
      assert { mediator.to_sfen == "position startpos moves 7i6h S*2d" }
    end

    it "dimension 形式で入力" do
      usi = Usi::Class2.new
      usi.execute("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d")
      assert { usi.mediator.to_sfen == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d" }
      usi.execute("position startpos moves 7i6h")
      assert { usi.mediator.to_sfen == "position startpos moves 7i6h" }
      usi.execute("position startpos")
      assert { usi.mediator.to_sfen ==  "position startpos" }
      usi.execute("position sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1")
      assert { usi.mediator.to_sfen == "position sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1" }
    end
  end
end
