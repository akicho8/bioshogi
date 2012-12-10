# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Point do
    subject { described_class }

    describe ".parse は、適当な文字列を内部座標に変換する" do
      it { described_class.parse("４三").name.should == "4三" }
      it { described_class.parse("43").name.should   == "4三" }
      it { described_class.parse([0, 0]).name.should == "9一" }

      it { expect { described_class.parse("四三") }.to raise_error(UnknownPositionName) }
      it { expect { described_class.parse(nil)    }.to raise_error(MustNotHappen) }
      it { expect { described_class.parse("")     }.to raise_error(PointSyntaxError) }
      it { expect { described_class.parse("0")    }.to raise_error(PointSyntaxError) }
    end

    describe ".[] は .parse の alias" do
      it { described_class["４三"].name.should == "4三" }
    end

    describe "#valid?" do
      it { described_class.parse("4三").valid?.should    == true }
      it { described_class.parse([-1, -1]).valid?.should == false }
    end

    describe "#name は、座標を表す" do
      it { described_class.parse("4三").name.should    == "4三"  }
      it { described_class.parse([-1, -1]).name.should == "盤外" }
    end

    describe "#to_s_digit は 7六歩(77) の 77 の部分を作るときに使う" do
      it { described_class.parse("４三").to_s_digit.should == "43"  }
    end
  end
end
