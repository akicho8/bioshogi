require "spec_helper"

RSpec.describe Bioshogi::Soldier do
  before do
    @attributes = { place: Bioshogi::Place["６八"], piece: Bioshogi::Piece["銀"], promoted: false, location: Bioshogi::Location[:black] }
  end

  it "基本形" do
    soldier = Bioshogi::Soldier.create(@attributes)
    assert { soldier.name == "▲６八銀" }
  end

  it "文字列から簡単に作る" do
    expect { Bioshogi::Soldier.from_str("６八銀") }.to raise_error(Bioshogi::BioshogiError)
    assert Bioshogi::Soldier.from_str("６八銀", location: Bioshogi::Location[:white]).name == "△６八銀"
    assert Bioshogi::Soldier.from_str("６八銀", location: Bioshogi::Location[:black]).name == "▲６八銀"
    assert Bioshogi::Soldier.from_str("▲６八銀").name == "▲６八銀"
  end

  it "== 同じ内容なら同じオブジェクトとする" do
    a = Bioshogi::Soldier.from_str("▲６八銀")
    b = Bioshogi::Soldier.from_str("▲６八銀")
    assert { (a == b) == true }
    assert { {a => true}[b] == true }
  end

  it "Bioshogi::Place の #eql? と #hash の定義で異なる object_id でも内容で判断して [obj1] - [obj2] = [] ができるようになる" do
    a = Bioshogi::Soldier.from_str("▲６八銀")
    b = Bioshogi::Soldier.from_str("▲６八銀")
    assert { (a.object_id != b.object_id) == true }
    assert { ([a] - [b]) == [] }
  end

  it "cloneしても同じ" do
    soldier = Bioshogi::Soldier.from_str("▲６八銀")
    assert { (Marshal.load(Marshal.dump(soldier)) == soldier) == true }
  end

  it "指し手" do
    soldier = Bioshogi::Soldier.from_str("▲６八全")
    origin_soldier = Bioshogi::Soldier.from_str("▲７九銀")
    assert Bioshogi::Hand::Move.create(soldier: soldier, origin_soldier: origin_soldier).to_kif == "▲６八銀成(79)"
    assert Bioshogi::Hand::Drop.create(soldier: Bioshogi::Soldier.from_str("▲５五飛")).to_kif == "▲５五飛打"
  end

  it "normal?" do
    assert { Bioshogi::Soldier.from_str("▲55歩").normal? }
    assert { !Bioshogi::Soldier.from_str("▲55と").normal? }
  end
end
