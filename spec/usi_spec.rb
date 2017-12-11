require_relative "spec_helper"

module Bushido
  describe "usi" do
    it "usi (sfen) 形式で出力" do
      mediator = Mediator.new
      mediator.board_reset
      mediator.to_sfen.should == "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
      mediator.pieces_set("▲銀△銀銀")
      # puts mediator
      mediator.board.to_sfen.should == "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL"
      mediator.to_sfen.should == "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1"
      mediator.execute("▲６八銀")
      mediator.hand_logs.last.to_sfen.should == "7i6h"
      mediator.to_sfen.should == "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL w S2s 2"
      mediator.execute("△２四銀打")
      mediator.hand_logs.last.to_sfen.should == "S*2d"
      mediator.to_sfen.should == "lnsgkgsnl/1r5b1/ppppppppp/7s1/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL b Ss 3"
      mediator.first_state_board_sfen.should == "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
      # puts mediator.board
      mediator.to_usi_position.should == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7i6h S*2d"
    end

    it "position 形式で入力" do
      usi = Usi.new
      usi.execute("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d")
      usi.mediator.to_usi_position.should == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d"
      usi.execute("position startpos moves 7i6h")
      usi.mediator.to_usi_position.should == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7i6h"
      usi.execute("position startpos")
      usi.mediator.to_usi_position(force_sfen: false).should ==  "position startpos"
      usi.mediator.to_usi_position.should == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
      usi.execute("position sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1")
      usi.mediator.to_usi_position.should == "position sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1"
    end
  end
end
