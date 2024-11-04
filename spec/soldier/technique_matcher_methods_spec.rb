require "spec_helper"

module Bioshogi
  describe Soldier::TechniqueMatcherMethods do
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

    it "左右の壁に近い方に進むときの符号(先手視点なので先後関係なし)" do
      assert { Soldier.from_str("▲41歩").sign_to_goto_closer_side == 1  }
      assert { Soldier.from_str("△41歩").sign_to_goto_closer_side == 1  }
      assert { Soldier.from_str("▲51歩").sign_to_goto_closer_side == -1 }
      assert { Soldier.from_str("△51歩").sign_to_goto_closer_side == -1 }
      assert { Soldier.from_str("▲61歩").sign_to_goto_closer_side == -1 }
      assert { Soldier.from_str("△61歩").sign_to_goto_closer_side == -1 }
    end

    it "左右の壁に近い方に進むときの符号(先手視点なので先後関係なし)" do
      assert { Soldier.from_str("▲41歩").sign_to_goto_closer_side == 1  }
      assert { Soldier.from_str("△41歩").sign_to_goto_closer_side == 1  }
      assert { Soldier.from_str("▲51歩").sign_to_goto_closer_side == -1 }
      assert { Soldier.from_str("△51歩").sign_to_goto_closer_side == -1 }
      assert { Soldier.from_str("▲61歩").sign_to_goto_closer_side == -1 }
      assert { Soldier.from_str("△61歩").sign_to_goto_closer_side == -1 }
    end

    it "tarehu_ikeru?" do
      assert { Soldier.from_str("▲11歩").tarehu_ikeru? == false }
      assert { Soldier.from_str("▲12歩").tarehu_ikeru? == true  }
      assert { Soldier.from_str("▲13歩").tarehu_ikeru? == true  }
      assert { Soldier.from_str("▲14歩").tarehu_ikeru? == true  }
      assert { Soldier.from_str("▲15歩").tarehu_ikeru? == false }
    end

    it "to_bottom_place" do
      assert { Soldier.from_str("▲11歩").to_bottom_place.name == "１九" }
      assert { Soldier.from_str("▲15歩").to_bottom_place.name == "１九" }
      assert { Soldier.from_str("▲19歩").to_bottom_place.name == "１九" }
    end

    it "maeni_ittyokusen" do
      assert { Soldier.from_str("▲19香").maeni_ittyokusen? == true  }
      assert { Soldier.from_str("▲19飛").maeni_ittyokusen? == true  }
      assert { Soldier.from_str("▲19杏").maeni_ittyokusen? == false }
      assert { Soldier.from_str("▲19角").maeni_ittyokusen? == false }
    end
  end
end
