require "spec_helper"

module Bioshogi
  describe Sfen do
    it "改行は正規表現に含めない" do
      assert { Sfen.parse("position startpos moves 2g2f\n3c3d").moves == ["2g2f"] }
      assert { Sfen.parse("position startpos moves 2g2f\n").moves     == ["2g2f"] }
    end

    describe "SFENと認識したものの読み取りに失敗した場合" do
      it "改行を含む" do
        expect {
          Sfen.parse("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL x - 1 moves 2g2f\n3c3d")
        }.to raise_error(SyntaxDefact, /途中で改行を含めないでください/)
      end
      it "2つ以上のスペースを含む" do
        expect {
          Sfen.parse("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b  1")
        }.to raise_error(SyntaxDefact, /2つ以上のスペース/)
      end
    end

    it "属性" do
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

    it "to_h" do
      assert { Sfen.parse("position startpos moves 5g5f 8c8d").to_h }
    end

    it "position も sfen も省略できる" do
      assert { Sfen.accept?("sfen lnsgkgsnl/1r5b1/+ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d") }
      assert { Sfen.accept?("lnsgkgsnl/1r5b1/+ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d") }
    end

    it "startposを外す・つける" do
      assert { Sfen.startpos_remove("position startpos") == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1" }
      assert { Sfen.startpos_embed("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1") == "position startpos" }
    end
  end
end
