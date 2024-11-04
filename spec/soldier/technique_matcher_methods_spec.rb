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

    it "maeni_ittyokusen" do
      assert { Soldier.from_str("▲19香").maeni_ittyokusen? == true  }
      assert { Soldier.from_str("▲19飛").maeni_ittyokusen? == true  }
      assert { Soldier.from_str("▲19杏").maeni_ittyokusen? == false }
      assert { Soldier.from_str("▲19角").maeni_ittyokusen? == false }
    end

    it "move_to_*" do
      assert { Soldier.from_str("△34飛").move_to_bottom.name == "３一" }
      assert { Soldier.from_str("△34飛").move_to_top.name    == "３九" }
      assert { Soldier.from_str("△34飛").move_to_right.name  == "９四" }
      assert { Soldier.from_str("△34飛").move_to_left.name   == "１四" }
    end

    it "*_spaces" do
      assert { Soldier.from_str("△34飛").top_spaces    == 5 }
      assert { Soldier.from_str("△34飛").bottom_spaces == 3 }
      assert { Soldier.from_str("△34飛").left_spaces   == 2 }
      assert { Soldier.from_str("△34飛").right_spaces  == 6 }
    end

    it "x_is_*?" do
      assert { Soldier.from_str("△34飛").x_is_two_to_eight?   == true  }
      assert { Soldier.from_str("△34飛").x_is_two_or_eight?   == false }
      assert { Soldier.from_str("△34飛").x_is_three_to_seven? == true  }
      assert { Soldier.from_str("△34飛").x_is_center?         == false }
      assert { Soldier.from_str("△34飛").x_is_left_or_right?  == false }
    end

    it "yondanme?" do
      assert { Soldier.from_str("△55玉").yondanme? == false }
      assert { Soldier.from_str("△56玉").yondanme? == true  }
      assert { Soldier.from_str("△57玉").yondanme? == false }
    end

    it "sandanme?" do
      assert { Soldier.from_str("△56玉").sandanme? == false }
      assert { Soldier.from_str("△57玉").sandanme? == true  }
      assert { Soldier.from_str("△58玉").sandanme? == false }
    end
  end
end
