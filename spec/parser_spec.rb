require "spec_helper"

module Bioshogi
  describe Parser do
    describe "判定" do
      it "KIF" do
        assert { Parser.parse("手数-指手-消費時間").class == Parser::KifParser }
        assert { Parser.parse("1 76歩").class == Parser::KifParser }
        assert { Parser.parse("1 投了").class == Parser::KifParser }
      end
      it "KI2" do
        assert { Parser.parse("68銀").class == Parser::Ki2Parser }
        assert { Parser.parse("☗68銀").class == Parser::Ki2Parser }
        assert { Parser.parse("").class     == Parser::Ki2Parser }
        assert { Parser.parse(nil).class    == Parser::Ki2Parser }
      end
    end

    it "ヘッダー行のセパレータは全角セミコロン" do
      assert { Parser.parse("a：b").header.to_h == {"a" => "b"} }
      assert { Parser.parse("a:b：c").header.to_h == {"a:b" => "c"} }
    end

    it "ヘッダー行のセパレータに半角を含めると時間の部分のセミコロンと衝突するので対応しない" do
      Parser.parse("a:b").header.to_h.should_not == {"a" => "b"}
    end

    it "日時の場合正規化する" do
      assert { Parser.parse("開始日時：2000-1-1  1:23:45").header.to_h == {"開始日時" => "2000/01/01 01:23:45"} }
      assert { Parser.parse("終了日時：2000/1/1 01:23:45").header.to_h == {"終了日時" => "2000/01/01 01:23:45"} }
    end
  end
end
