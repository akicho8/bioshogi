require_relative "spec_helper"

module Bushido
  describe Parser do
    it "ヘッダー行のセパレータは全角セミコロン" do
      Parser.parse("a：b").header.should == {"a" => "b"}
      Parser.parse("a:b：c").header.should == {"a:b" => "c"}
    end

    it "ヘッダー行のセパレータに半角を含めると時間の部分のセミコロンと衝突するので対応しない" do
      Parser.parse("a:b").header.should_not == {"a" => "b"}
    end
  end
end
