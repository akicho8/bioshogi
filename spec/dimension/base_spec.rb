require "spec_helper"

RSpec.describe Bioshogi::Dimension::Base do
  it "distance" do
    assert { Bioshogi::Dimension::Column.fetch("1").distance(Bioshogi::Dimension::Column.fetch("3")) == 2 }
    assert { Bioshogi::Dimension::Column.fetch("3").distance(Bioshogi::Dimension::Column.fetch("1")) == 2 }
  end

  it "first, last, half" do
    assert { Bioshogi::Dimension::Column.first.hankaku_number == "9" }
    assert { Bioshogi::Dimension::Column.last.hankaku_number  == "1" }
    assert { Bioshogi::Dimension::Column.half.hankaku_number  == "5" }
  end
end
