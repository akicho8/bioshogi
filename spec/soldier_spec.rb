require_relative "spec_helper"

module Warabi
  describe Soldier do
    before do
      @attributes = {point: Point["６八"], piece: Piece["銀"], promoted: false, location: Location[:black]}
    end

    it "基本形" do
      soldier = Soldier.create(@attributes)
      soldier.name.should == "▲６八銀"
    end

    it "文字列から簡単に作る" do
      expect { Soldier.from_str("６八銀") }.to raise_error(WarabiError)
      Soldier.from_str("６八銀", location: Location[:white]).name.should == "△６八銀"
      Soldier.from_str("６八銀", location: Location[:black]).name.should == "▲６八銀"
      Soldier.from_str("▲６八銀").name.should == "▲６八銀"
    end

    it "== 同じ内容なら同じオブジェクトとする" do
      a = Soldier.from_str("▲６八銀")
      b = Soldier.from_str("▲６八銀")
      a.should== b
      {a => true}[b].should == true
    end

    it "Point の #eql? と #hash の定義で異なる object_id でも内容で判断して [obj1] - [obj2] = [] ができるようになる" do
      a = Soldier.from_str("▲６八銀")
      b = Soldier.from_str("▲６八銀")
      (a.object_id != b.object_id).should == true
      ([a] - [b]).should == []
    end

    it "cloneしても同じ" do
      soldier = Soldier.from_str("▲６八銀")
      (Marshal.load(Marshal.dump(soldier)) == soldier).should == true
    end

    describe "Brainの指し手チェック用" do
      describe Moved do
        it "#to_hand" do
          Moved.create(@attributes.merge(origin_soldier: Soldier.from_str("▲７九銀"), promoted_trigger: true)).to_hand.should == "▲６八銀成(79)"
        end
      end

      describe Direct do
        it "#to_hand" do
          Direct.create(@attributes).to_hand.should == "▲６八銀打"
        end
      end
    end
  end
end
