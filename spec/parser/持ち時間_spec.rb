require_relative "../spec_helper"

module Warabi
  describe "持ち時間" do
    it do
      assert Parser.parse("持ち時間：１時間２分").to_kif.match?(/：1時間2分$/)
      assert Parser.parse("持ち時間：１時間").to_kif.match?(/：1時間$/)
      assert Parser.parse("持ち時間：２分").to_kif.match?(/：2分$/)
      assert Parser.parse("持ち時間：62分").to_kif.match?(/：1時間2分/)
      assert Parser::CsaParser.parse("$TIME_LIMIT:12:34+5").to_kif.match?(/持ち時間：12時間34分 \(1手5秒\)/)
    end
  end
end
