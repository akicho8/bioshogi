require_relative "spec_helper"

module Warabi
  describe "usi" do
    it "usi (sfen) 形式で出力" do
      mediator = Mediator.new
      mediator.placement_from_preset
      mediator.play_standby
      mediator.to_sfen.should == "position startpos"
      mediator.to_long_sfen.should == "sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
      mediator.pieces_set("▲銀△銀銀")
      # puts mediator
      mediator.board.to_sfen.should == "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL"
      mediator.to_sfen.should == "position startpos"
      mediator.execute("▲６八銀")
      mediator.hand_logs.last.to_sfen.should == "7i6h"
      mediator.to_sfen.should == "position startpos moves 7i6h"
      mediator.execute("△２四銀打")
      mediator.hand_logs.last.to_sfen.should == "S*2d"
      mediator.to_sfen.should == "position startpos moves 7i6h S*2d"
      mediator.first_state_board_sfen.should == "startpos"
      # puts mediator.board
      mediator.to_sfen.should == "position startpos moves 7i6h S*2d"
    end

    it "dimension 形式で入力" do
      usi = Usi::Class2.new
      usi.execute("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d")
      usi.mediator.to_sfen.should == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d"
      usi.execute("position startpos moves 7i6h")
      usi.mediator.to_sfen.should == "position startpos moves 7i6h"
      usi.execute("position startpos")
      usi.mediator.to_sfen.should ==  "position startpos"
      usi.execute("position sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1")
      usi.mediator.to_sfen.should == "position sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1"
    end
  end
end
