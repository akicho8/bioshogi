require_relative "spec_helper"

module Bushido
  describe "usi" do
    it "to_sfen" do
      mediator = Mediator.new
      mediator.board_reset
      mediator.to_sfen.should == "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
      mediator.pieces_set("▲銀△銀銀")
      # puts mediator
      mediator.board.to_sfen.should == "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL"
      mediator.to_sfen.should == "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1"
      mediator.execute("▲６八銀")
      mediator.hand_logs.last.to_sfen.should == "7i6h"
      mediator.to_sfen.should == "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL w S2s 1"
      mediator.execute("△２四銀打")
      mediator.hand_logs.last.to_sfen.should == "S*2d"
      mediator.to_sfen.should == "lnsgkgsnl/1r5b1/ppppppppp/7s1/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL b Ss 1"
      mediator.first_state_board_sfen.should == "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
      # puts mediator.board
      mediator.to_usi_position.should == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7i6h S*2d"
    end
  end
end
