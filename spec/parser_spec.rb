require "spec_helper"

RSpec.describe Bioshogi::Parser do
  it "空の棋譜はKIF形式とする" do
    assert { Bioshogi::Parser.accepted_class("") == Bioshogi::Parser::KifParser }
  end

  it "空の棋譜をエラーとしない" do
    assert { Bioshogi::Parser.parse("").to_kif }
    assert { Bioshogi::Parser.parse("").to_csa }
    assert { Bioshogi::Parser.parse("").to_sfen }
    assert { Bioshogi::Parser.parse("").to_bod }
  end

  describe "判定" do
    it "KIF" do
      assert { Bioshogi::Parser.parse("手数-指手-消費時間").class == Bioshogi::Parser::KifParser }
      assert { Bioshogi::Parser.parse("1 76歩").class == Bioshogi::Parser::KifParser }
      assert { Bioshogi::Parser.parse("1 投了").class == Bioshogi::Parser::KifParser }
    end
    it "KI2" do
      assert { Bioshogi::Parser.parse("68銀").class == Bioshogi::Parser::Ki2Parser }
      assert { Bioshogi::Parser.parse("☗68銀").class == Bioshogi::Parser::Ki2Parser }
    end
    it "空" do
      assert { Bioshogi::Parser.parse("") rescue $!.class == Bioshogi::FileFormatError }
      assert { Bioshogi::Parser.parse(nil) rescue $!.class == Bioshogi::FileFormatError }
    end
  end

  it "ヘッダー行のセパレータは全角セミコロン" do
    assert { Bioshogi::Parser.parse("a：b").pi.header.to_h == { "a" => "b" } }
    assert { Bioshogi::Parser.parse("a:b：c").pi.header.to_h == { "a:b" => "c" } }
  end

  it "ヘッダー行のセパレータに半角を含めると時間の部分のセミコロンと衝突するので対応しない" do
    assert { Bioshogi::Parser.parse("a:b") rescue $!.class == Bioshogi::FileFormatError }
  end

  it "日時の場合正規化する" do
    assert { Bioshogi::Parser.parse("開始日時：2000-1-1  1:23:45").pi.header.to_h == { "開始日時" => "2000/01/01 01:23:45" } }
    assert { Bioshogi::Parser.parse("終了日時：2000/1/1 01:23:45").pi.header.to_h == { "終了日時" => "2000/01/01 01:23:45" } }
  end
end
