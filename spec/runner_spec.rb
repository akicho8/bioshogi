require_relative "spec_helper"

module Bushido
  describe Runner do
    describe "指し手の正規表現" do
      def test1(s)
        s.match(Runner.input_regexp).named_captures.compact
      end

      it "拾わない" do
        assert_nil "歩".match(Runner.input_regexp)
        assert_nil "99".match(Runner.input_regexp)
        assert_nil "同".match(Runner.input_regexp)
        assert_nil "99同".match(Runner.input_regexp)
        assert_nil "同99".match(Runner.input_regexp)
      end

      it "拾う" do
        test1("24歩").should   == {"point_to" => "24", "piece" => "歩", "motion1" => ""}
        test1("同歩").should   == {"same" => "同", "piece" => "歩", "motion1" => ""}
      end

      it "紙面の改ページのあと同の前に座標を書く場合があるため「24同歩」に対応する。ついでに「同24歩」にも対応" do
        test1("24同歩").should == {"point_to" => "24", "same" => "同", "piece" => "歩", "motion1" => ""}
        test1("同24歩").should == {"point_to" => "24", "same" => "同", "piece" => "歩", "motion1" => ""}
      end

      it "元座標あり" do
        test1("74歩(77)").should == {"point_to" => "74", "piece" => "歩", "motion1" => "", "point_from" => "(77)"}
      end
    end
  end
end
