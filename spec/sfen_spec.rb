require_relative "spec_helper"

module Warabi
  describe Sfen do
    it do
      sfen = Sfen.parse("one_place sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d")
      sfen.soldiers.first(3).collect(&:name).should == ["△９一香", "△８一桂", "△７一銀"]
      sfen.location.key.should == :black
      sfen.move_infos.should == [{:input=>"7i6h"}, {:input=>"S*2d"}]
      sfen.piece_counts.should == {:black=>{:silver=>1}, :white=>{:silver=>2}}
      sfen.turn_counter.should == 0
      sfen.handicap?.should == false

      sfen = Sfen.parse("one_place startpos")
      sfen.location.key.should == :black
    end
  end
end
