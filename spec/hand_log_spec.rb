require "spec_helper"

RSpec.describe Bioshogi::HandLog do
  it "to_xxx" do
    move_hand = Bioshogi::Hand::Move.create(soldier: Bioshogi::Soldier.from_str("▲６八銀"), origin_soldier: Bioshogi::Soldier.from_str("▲７九銀"))
    object = Bioshogi::HandLog.new(move_hand: move_hand, candidate_soldiers: [])
    assert { object.to_kif == "６八銀(79)" }
    assert { object.to_ki2 == "６八銀" }
    assert { object.to_csa == "+7968GI" }
    assert { object.to_sfen == "7i6h" }
  end

  it "時間が指し手に結び付いている" do
    parser = Bioshogi::Parser.parse(<<~EOT)
    手数----指手---------消費時間--
      1 ２六歩(27) (00:01/00:00:00)
    2 ３四歩(33) (01:00/00:00:00)
    3 ２五歩(26) (00:02/00:00:00)
    4 ３三角(22) (02:00/00:00:00)
    5 ７六歩(77) (00:03/00:00:00)
    6 ４二銀(31) (03:00/00:00:00)
    EOT

    assert { parser.container.hand_logs.last.single_clock.to_s == "(03:00/00:06:00)" }
  end
end
