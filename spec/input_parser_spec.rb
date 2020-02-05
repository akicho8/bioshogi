require_relative "spec_helper"

module Bioshogi
  describe InputParser do
    def test1(s)
      s.match(InputParser.regexp).named_captures.compact
    end

    it do
      list = [
        "６八銀左",
        "△６八全",
        "△６八銀成",
        "△６八銀打",
        "☖68銀",
        "☗68銀",
        "△同銀",
        "△同銀成",
        "７六歩(77)",
        "7677FU",
        "-7677FU",
        "+0077RY",
        "8c8d",
        "P*2f",
        "4e5c+",
      ]
      assert { InputParser.scan(list.join) == list }
    end

    it "拾わない" do
      assert_nil "歩".match(InputParser.regexp)
      assert_nil "99".match(InputParser.regexp)
      assert_nil "同".match(InputParser.regexp)
      assert_nil "99同".match(InputParser.regexp)
      assert_nil "同99".match(InputParser.regexp)
    end

    it "拾う" do
      assert { test1("24歩")   == {"kif_place" => "24", "kif_piece" => "歩"} }
      assert { test1("同歩")   == {"ki2_same" => "同", "kif_piece" => "歩"} }
    end

    it "紙面の改ページのあと同の前に座標を書く場合があるため「24同歩」に対応する。ついでに「同24歩」にも対応" do
      assert { test1("24同歩") == {"kif_place" => "24", "ki2_same" => "同", "kif_piece" => "歩"} }
      assert { test1("同24歩") == {"kif_place" => "24", "ki2_same" => "同", "kif_piece" => "歩"} }
    end

    it "元座標あり" do
      assert { test1("74歩(77)") == {"kif_place" => "74", "kif_piece" => "歩", "kif_place_from" => "(77)"} }
    end
  end
end
