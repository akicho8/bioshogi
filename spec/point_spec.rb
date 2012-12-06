# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Point do
    describe ".parse" do
      it { Point.parse("7六").name.should  == "7六" }
      it { Point.parse("76").name.should   == "7六" }
      it { Point.parse([2, 5]).name.should == "7六" }

      it { proc{Point.parse("七六")}.should raise_error(SyntaxError) }
      it { proc{Point.parse(nil)}.should    raise_error(SyntaxError) }
      it { proc{Point.parse("")}.should     raise_error(SyntaxError) }
      it { proc{Point.parse("0")}.should    raise_error(SyntaxError) }
    end

    describe "#valid?" do
      it { Point.parse([0, 0]).should be_valid }
      it { Point.parse([-1, -1]).should_not be_valid }
    end

    describe "#name" do
      it { Point.parse([0, 0]).name.should   == "9一"  }
      it { Point.parse([-1, -1]).name.should == "盤外" }
    end
  end
end
