require_relative "spec_helper"

module Warabi
  describe PlayerExecutor do
    describe "指し手の正規表現" do
      def test1(s)
        s.match(InputParser.regexp).named_captures.compact
      end

      it "拾わない" do
        assert_nil "歩".match(InputParser.regexp)
        assert_nil "99".match(InputParser.regexp)
        assert_nil "同".match(InputParser.regexp)
        assert_nil "99同".match(InputParser.regexp)
        assert_nil "同99".match(InputParser.regexp)
      end

      it "拾う" do
        test1("24歩").should   == {"point" => "24", "piece" => "歩", "motion_part" => ""}
        test1("同歩").should   == {"same" => "同", "piece" => "歩", "motion_part" => ""}
      end

      it "紙面の改ページのあと同の前に座標を書く場合があるため「24同歩」に対応する。ついでに「同24歩」にも対応" do
        test1("24同歩").should == {"point" => "24", "same" => "同", "piece" => "歩", "motion_part" => ""}
        test1("同24歩").should == {"point" => "24", "same" => "同", "piece" => "歩", "motion_part" => ""}
      end

      it "元座標あり" do
        test1("74歩(77)").should == {"point" => "74", "piece" => "歩", "motion_part" => "", "point_from" => "(77)"}
      end
    end
  end
end
