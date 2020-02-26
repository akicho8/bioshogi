require_relative "spec_helper"

module Bioshogi
  describe Sfen do
    it do
      sfen = Sfen.parse("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d")
      assert { sfen.soldiers.first(3).collect(&:name) == ["△９一香", "△８一桂", "△７一銀"] }
      assert { sfen.location.key == :black }
      assert { sfen.move_infos == [{:input => "7i6h"}, {:input => "S*2d"}] }
      assert { sfen.piece_counts == {:black => {:silver => 1}, :white => {:silver => 2}} }
      assert { sfen.turn_base == 0 }
      assert { sfen.handicap? == false }
    end

    it "startpos" do
      sfen = Sfen.parse("position startpos")
      assert { sfen.location.key == :black }
    end

    it "主にKENTO用" do
      sfen = Sfen.parse("position startpos moves 5g5f 8c8d")
      assert { sfen.moves == ["5g5f", "8c8d"] }
      assert { sfen.board_and_b_or_w_and_piece_box_and_turn == "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1" }
      assert { sfen.kento_app_url == "https://www.kento-shogi.com/?initpos=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1&moves=5g5f.8c8d" }
      assert { sfen.kento_app_query_hash == { initpos: "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1", moves: "5g5f.8c8d" } }
    end
  end
end
