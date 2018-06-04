require_relative "spec_helper"

module Warabi
  describe Parser do
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
