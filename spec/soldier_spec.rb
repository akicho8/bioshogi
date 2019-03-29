require_relative "spec_helper"

module Bioshogi
  describe Soldier do
    before do
      @attributes = {place: Place["６八"], piece: Piece["銀"], promoted: false, location: Location[:black]}
    end

    it "基本形" do
      soldier = Soldier.create(@attributes)
      assert { soldier.name == "▲６八銀" }
    end

    it "文字列から簡単に作る" do
      expect { Soldier.from_str("６八銀") }.to raise_error(BioshogiError)
      assert Soldier.from_str("６八銀", location: Location[:white]).name == "△６八銀"
      assert Soldier.from_str("６八銀", location: Location[:black]).name == "▲６八銀"
      assert Soldier.from_str("▲６八銀").name == "▲６八銀"
    end

    it "== 同じ内容なら同じオブジェクトとする" do
      a = Soldier.from_str("▲６八銀")
      b = Soldier.from_str("▲６八銀")
      assert { (a == b) == true }
      assert { {a => true}[b] == true }
    end

    it "Place の #eql? と #hash の定義で異なる object_id でも内容で判断して [obj1] - [obj2] = [] ができるようになる" do
      a = Soldier.from_str("▲６八銀")
      b = Soldier.from_str("▲６八銀")
      assert { (a.object_id != b.object_id) == true }
      assert { ([a] - [b]) == [] }
    end

    it "cloneしても同じ" do
      soldier = Soldier.from_str("▲６八銀")
      assert { (Marshal.load(Marshal.dump(soldier)) == soldier) == true }
    end

    it "指し手" do
      soldier = Soldier.from_str("▲６八全")
      origin_soldier = Soldier.from_str("▲７九銀")
      assert MoveHand.create(soldier: soldier, origin_soldier: origin_soldier).to_kif == "▲６八銀成(79)"
      assert DropHand.create(soldier: Soldier.from_str("▲５五飛")).to_kif == "▲５五飛打"
    end

    it "底からの移動幅" do
      assert { Soldier.from_str("▲19香").bottom_spaces == 0 }
      assert { Soldier.from_str("▲18香").bottom_spaces == 1 }
      assert { Soldier.from_str("△11香").bottom_spaces == 0 }
      assert { Soldier.from_str("△12香").bottom_spaces == 1 }
    end

    it "上からの隙間" do
      assert { Soldier.from_str("▲19香").top_spaces == 8 }
      assert { Soldier.from_str("▲18香").top_spaces == 7 }
      assert { Soldier.from_str("△11香").top_spaces == 8 }
      assert { Soldier.from_str("△12香").top_spaces == 7 }
    end

    it "「左右の壁からどれだけ離れているかの値」の小さい方(先後関係なし)" do
      assert { Soldier.from_str("▲41歩").smaller_one_of_side_spaces == 3 }
      assert { Soldier.from_str("△41歩").smaller_one_of_side_spaces == 3 }
      assert { Soldier.from_str("▲51歩").smaller_one_of_side_spaces == 4 }
      assert { Soldier.from_str("△51歩").smaller_one_of_side_spaces == 4 }
      assert { Soldier.from_str("▲61歩").smaller_one_of_side_spaces == 3 }
      assert { Soldier.from_str("△61歩").smaller_one_of_side_spaces == 3 }
    end

    it "左右の壁に近い方に進むときの符号(先手視点なので先後関係なし)" do
      assert { Soldier.from_str("▲41歩").sign_to_goto_closer_side == 1  }
      assert { Soldier.from_str("△41歩").sign_to_goto_closer_side == 1  }
      assert { Soldier.from_str("▲51歩").sign_to_goto_closer_side == -1 }
      assert { Soldier.from_str("△51歩").sign_to_goto_closer_side == -1 }
      assert { Soldier.from_str("▲61歩").sign_to_goto_closer_side == -1 }
      assert { Soldier.from_str("△61歩").sign_to_goto_closer_side == -1 }
    end
  end
end
