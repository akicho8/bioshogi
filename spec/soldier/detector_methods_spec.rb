require "spec_helper"

RSpec.describe Bioshogi::Soldier::DetectorMethods do
  it "底からの移動幅" do
    assert { Bioshogi::Soldier.from_str("▲19香").bottom_spaces == 0 }
    assert { Bioshogi::Soldier.from_str("▲18香").bottom_spaces == 1 }
    assert { Bioshogi::Soldier.from_str("△11香").bottom_spaces == 0 }
    assert { Bioshogi::Soldier.from_str("△12香").bottom_spaces == 1 }
  end

  it "上からの隙間" do
    assert { Bioshogi::Soldier.from_str("▲19香").top_spaces == 8 }
    assert { Bioshogi::Soldier.from_str("▲18香").top_spaces == 7 }
    assert { Bioshogi::Soldier.from_str("△11香").top_spaces == 8 }
    assert { Bioshogi::Soldier.from_str("△12香").top_spaces == 7 }
  end

  it "「左右の壁からどれだけ離れているかの値」の小さい方(先後関係なし)" do
    assert { Bioshogi::Soldier.from_str("▲41歩").column_spaces_min == 3 }
    assert { Bioshogi::Soldier.from_str("△41歩").column_spaces_min == 3 }
    assert { Bioshogi::Soldier.from_str("▲51歩").column_spaces_min == 4 }
    assert { Bioshogi::Soldier.from_str("△51歩").column_spaces_min == 4 }
    assert { Bioshogi::Soldier.from_str("▲61歩").column_spaces_min == 3 }
    assert { Bioshogi::Soldier.from_str("△61歩").column_spaces_min == 3 }
  end

  it "左右の壁に近い方に進むときの符号(先手視点なので先後関係なし)" do
    assert { Bioshogi::Soldier.from_str("▲41歩").align_arrow == :right }
    assert { Bioshogi::Soldier.from_str("△41歩").align_arrow == :left  }
    assert { Bioshogi::Soldier.from_str("▲51歩").align_arrow == :left  }
    assert { Bioshogi::Soldier.from_str("△51歩").align_arrow == :left  }
    assert { Bioshogi::Soldier.from_str("▲61歩").align_arrow == :left  }
    assert { Bioshogi::Soldier.from_str("△61歩").align_arrow == :right }
  end

  it "tarefu_desuka?" do
    assert { Bioshogi::Soldier.from_str("▲11歩").tarefu_desuka? == false }
    assert { Bioshogi::Soldier.from_str("▲12歩").tarefu_desuka? == true  }
    assert { Bioshogi::Soldier.from_str("▲13歩").tarefu_desuka? == true  }
    assert { Bioshogi::Soldier.from_str("▲14歩").tarefu_desuka? == true  }
    assert { Bioshogi::Soldier.from_str("▲15歩").tarefu_desuka? == false }
  end

  it "boar_mode" do
    assert { Bioshogi::Soldier.from_str("▲19香").boar_mode? == true  }
    assert { Bioshogi::Soldier.from_str("▲19飛").boar_mode? == true  }
    assert { Bioshogi::Soldier.from_str("▲19杏").boar_mode? == false }
    assert { Bioshogi::Soldier.from_str("▲19角").boar_mode? == false }
  end

  it "move_to_*" do
    assert { Bioshogi::Soldier.from_str("△34飛").move_to_bottom_edge.name == "３一" }
    assert { Bioshogi::Soldier.from_str("△34飛").move_to_top_edge.name    == "３九" }
    assert { Bioshogi::Soldier.from_str("△34飛").move_to_right_edge.name  == "９四" }
    assert { Bioshogi::Soldier.from_str("△34飛").move_to_left_edge.name   == "１四" }
  end

  it "relative_move_to" do
    assert { Bioshogi::Soldier.from_str("△34飛").relative_move_to(:up).name                    == "３五" }
    assert { Bioshogi::Soldier.from_str("△34飛").relative_move_to(:up, magnification: 0).name  == "３四" }
    assert { Bioshogi::Soldier.from_str("△34飛").relative_move_to(:up, magnification: 1).name  == "３五" }
    assert { Bioshogi::Soldier.from_str("△34飛").relative_move_to(:up, magnification: 2).name  == "３六" }
    assert { Bioshogi::Soldier.from_str("△34飛").relative_move_to(:up, magnification: -2).name == "３二" }
  end

  it "*_spaces" do
    assert { Bioshogi::Soldier.from_str("△34飛").top_spaces    == 5 }
    assert { Bioshogi::Soldier.from_str("△34飛").bottom_spaces == 3 }
    assert { Bioshogi::Soldier.from_str("△34飛").left_spaces   == 2 }
    assert { Bioshogi::Soldier.from_str("△34飛").right_spaces  == 6 }
  end

  it "column_is_*?" do
    assert { Bioshogi::Soldier.from_str("△34飛").column_is_second_to_eighth?   == true  }
    assert { Bioshogi::Soldier.from_str("△34飛").column_is_second_or_eighth?   == false }
    assert { Bioshogi::Soldier.from_str("△34飛").column_is_three_to_seven? == true  }
    assert { Bioshogi::Soldier.from_str("△34飛").column_is_center?         == false }
    assert { Bioshogi::Soldier.from_str("△34飛").column_is_edge?           == false }
    assert { Bioshogi::Soldier.from_str("△34飛").column_is_right_side?     == false }
    assert { Bioshogi::Soldier.from_str("△34飛").column_is_left_side?      == true  }
    assert { Bioshogi::Soldier.from_str("△34飛").column_is_right_edge?     == false }
    assert { Bioshogi::Soldier.from_str("△34飛").column_is_left_edge?      == false }
  end

  it "atoippo_nyuugyoku?" do
    assert { Bioshogi::Soldier.from_str("△55玉").atoippo_nyuugyoku? == false }
    assert { Bioshogi::Soldier.from_str("△56玉").atoippo_nyuugyoku? == true  }
    assert { Bioshogi::Soldier.from_str("△57玉").atoippo_nyuugyoku? == false }
  end

  it "just_nyuugyoku?" do
    assert { Bioshogi::Soldier.from_str("△56玉").just_nyuugyoku? == false }
    assert { Bioshogi::Soldier.from_str("△57玉").just_nyuugyoku? == true  }
    assert { Bioshogi::Soldier.from_str("△58玉").just_nyuugyoku? == false }
  end

  it "king_default_place?" do
    assert { Bioshogi::Soldier.from_str("△51飛").king_default_place? }
    assert { Bioshogi::Soldier.from_str("▲59飛").king_default_place? }
  end

  it "both_side_without_corner?" do
    assert { Bioshogi::Soldier.from_str("▲11玉").both_side_without_corner? == false }
    assert { Bioshogi::Soldier.from_str("▲12玉").both_side_without_corner? == true }
    assert { Bioshogi::Soldier.from_str("▲18玉").both_side_without_corner? == true }
    assert { Bioshogi::Soldier.from_str("▲19玉").both_side_without_corner? == false }

    assert { Bioshogi::Soldier.from_str("▲91玉").both_side_without_corner? == false }
    assert { Bioshogi::Soldier.from_str("▲92玉").both_side_without_corner? == true }
    assert { Bioshogi::Soldier.from_str("▲98玉").both_side_without_corner? == true }
    assert { Bioshogi::Soldier.from_str("▲99玉").both_side_without_corner? == false }

    assert { Bioshogi::Soldier.from_str("▲22玉").both_side_without_corner? == false }
  end
end
