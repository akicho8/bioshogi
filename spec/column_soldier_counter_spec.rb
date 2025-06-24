require "spec_helper"

RSpec.describe Bioshogi::ColumnSoldierCounter do
  it "縦に1列埋まると filled? が真になる" do
    column_soldier_counter = Bioshogi::ColumnSoldierCounter.new
    assert { column_soldier_counter.counts == [0, 0, 0, 0, 0, 0, 0, 0, 0] }
    column_soldier_counter.set(Bioshogi::Place["21"])
    assert { column_soldier_counter.counts == [0, 0, 0, 0, 0, 0, 0, 1, 0] }
    column_soldier_counter.set(Bioshogi::Place["22"])
    column_soldier_counter.set(Bioshogi::Place["23"])
    column_soldier_counter.set(Bioshogi::Place["24"])
    column_soldier_counter.set(Bioshogi::Place["25"])
    column_soldier_counter.set(Bioshogi::Place["26"])
    column_soldier_counter.set(Bioshogi::Place["27"])
    column_soldier_counter.set(Bioshogi::Place["28"])
    assert { column_soldier_counter.counts == [0, 0, 0, 0, 0, 0, 0, 8, 0] }
    assert { !column_soldier_counter.filled?(Bioshogi::Place["29"].column) }
    column_soldier_counter.set(Bioshogi::Place["29"])
    assert { column_soldier_counter.counts == [0, 0, 0, 0, 0, 0, 0, 9, 0] }
    assert { column_soldier_counter.filled?(Bioshogi::Place["29"].column) }
    column_soldier_counter.remove(Bioshogi::Place["29"])
    assert { column_soldier_counter.counts == [0, 0, 0, 0, 0, 0, 0, 8, 0] }
  end

  it "reset" do
    column_soldier_counter = Bioshogi::ColumnSoldierCounter.new
    column_soldier_counter.set(Bioshogi::Place["21"])
    assert { column_soldier_counter.counts == [0, 0, 0, 0, 0, 0, 0, 1, 0] }
    column_soldier_counter.reset
    assert { column_soldier_counter.counts == [0, 0, 0, 0, 0, 0, 0, 0, 0] }
  end

  it "指定の列に駒がない状態で削除しようとしたのでエラーになる" do
    column_soldier_counter = Bioshogi::ColumnSoldierCounter.new
    expect { column_soldier_counter.remove(Bioshogi::Place["21"]) }.to raise_error(Bioshogi::MustNotHappen)
  end

  it "指定の列が埋まっている状態でさらに置こうとしたのでエラーになる" do
    column_soldier_counter = Bioshogi::ColumnSoldierCounter.new
    Bioshogi::Dimension::Row.dimension_size.times { column_soldier_counter.set(Bioshogi::Place["21"]) }
    expect { column_soldier_counter.set(Bioshogi::Place["21"]) }.to raise_error(Bioshogi::MustNotHappen)
  end
end
