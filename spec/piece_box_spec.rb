require "spec_helper"

RSpec.describe Bioshogi::PieceBox do
  it "いろんなものに変換" do
    piece_box = Bioshogi::PieceBox.new(Bioshogi::Piece.s_to_h("飛玉角角"))
    assert { piece_box.to_sfen(:black) == "KR2B" }
    assert { piece_box.to_csa(:black) == "P+00OU00HI00KA00KA" }
    assert { piece_box.to_s(separator: "/") == "玉/飛/角二" }
    assert { piece_box.score == 45880 }
  end

  it "to_sfen は順序を固定する" do
    assert { Bioshogi::PieceBox.new(Bioshogi::Piece.s_to_h("玉飛角金銀桂香歩")).to_sfen(:black) == "KRBGSNLP" }
    assert { Bioshogi::PieceBox.new(Bioshogi::Piece.s_to_h("歩香桂銀金角飛玉")).to_sfen(:black) == "KRBGSNLP" }
  end

  it "内容が同じなら同じオブジェクトする" do
    a = Bioshogi::PieceBox.new(Bioshogi::Piece.s_to_h("飛玉"))
    b = Bioshogi::PieceBox.new(Bioshogi::Piece.s_to_h("玉飛"))
    assert { (a == b) == true }
  end

  it "引数のハッシュは破壊されない" do
    hash = { :king => 1 }.freeze
    piece_box = Bioshogi::PieceBox.new(hash)
    piece_box.add(king: 1)
    assert { piece_box == { :king => 2 } }
    assert { hash      == { :king => 1 } }
  end

  it "すべての駒が入っている" do
    assert { Bioshogi::PieceBox.real_box == { king: 2, rook: 2, bishop: 2, gold: 4, silver: 4, knight: 4, lance: 4, pawn: 18 } }
  end

  it "駒を+1して-1したら駒はなくなっている" do
    piece_box = Bioshogi::PieceBox.new
    assert { piece_box.exist?(:king) == false }
    piece_box.add(king: 1)
    assert { piece_box.exist?(:king) == true }
    piece_box.add(king: -1)
    assert { piece_box.exist?(:king) == false }
  end

  it "駒がないのに減らしたらエラー" do
    piece_box = Bioshogi::PieceBox.new
    proc { piece_box.add(king: -1) }.should raise_error(Bioshogi::HoldPieceNotFound)
  end
end
