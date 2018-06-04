require_relative "spec_helper"

module Warabi
  describe Sfen do
    it do
      sfen = Sfen.parse("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d")
      assert { sfen.soldiers.first(3).collect(&:name) == ["△９一香", "△８一桂", "△７一銀"] }
      assert { sfen.location.key == :black }
      assert { sfen.move_infos == [{:input=>"7i6h"}, {:input=>"S*2d"}] }
      assert { sfen.piece_counts == {:black=>{:silver=>1}, :white=>{:silver=>2}} }
      assert { sfen.turn_counter == 0 }
      assert { sfen.handicap? == false }

      sfen = Sfen.parse("position startpos")
      assert { sfen.location.key == :black }
    end
  end
end
