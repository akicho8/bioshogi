require_relative "spec_helper"

module Warabi
  describe Soldier do
    before do
      @attributes = {place: Place["６八"], piece: Piece["銀"], promoted: false, location: Location[:black]}
    end

    it "基本形" do
      soldier = Soldier.create(@attributes)
      assert { soldier.name == "▲６八銀" }
    end

    it "文字列から簡単に作る" do
      expect { Soldier.from_str("６八銀") }.to raise_error(WarabiError)
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
      assert { Soldier.from_str("▲19香").advance_level == 0 }
      assert { Soldier.from_str("▲18香").advance_level == 1 }
      assert { Soldier.from_str("△11香").advance_level == 0 }
      assert { Soldier.from_str("△12香").advance_level == 1 }
    end

    it "「左右の壁からどれだけ離れているかの値」の小さい方(先後関係なし)" do
      assert { Soldier.from_str("▲41歩").smaller_one_of_distance_to_wall == 3 }
      assert { Soldier.from_str("△41歩").smaller_one_of_distance_to_wall == 3 }
      assert { Soldier.from_str("▲51歩").smaller_one_of_distance_to_wall == 4 }
      assert { Soldier.from_str("△51歩").smaller_one_of_distance_to_wall == 4 }
      assert { Soldier.from_str("▲61歩").smaller_one_of_distance_to_wall == 3 }
      assert { Soldier.from_str("△61歩").smaller_one_of_distance_to_wall == 3 }
    end

    it "左右の壁に近い方に進むときの符号(先手視点なので先後関係なし)" do
      assert { Soldier.from_str("▲41歩").distance_to_wall_sign == 1  }
      assert { Soldier.from_str("△41歩").distance_to_wall_sign == 1  }
      assert { Soldier.from_str("▲51歩").distance_to_wall_sign == -1 }
      assert { Soldier.from_str("△51歩").distance_to_wall_sign == -1 }
      assert { Soldier.from_str("▲61歩").distance_to_wall_sign == -1 }
      assert { Soldier.from_str("△61歩").distance_to_wall_sign == -1 }
    end
  end
end
