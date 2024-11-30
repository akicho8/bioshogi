require "spec_helper"

module Bioshogi
  describe PillerCop do
    it "縦に1列埋まると active が true になる" do
      piller_cop = PillerCop.new
      assert { piller_cop.counts == [0, 0, 0, 0, 0, 0, 0, 0, 0] }
      piller_cop.set(Place["21"])
      assert { piller_cop.counts == [0, 0, 0, 0, 0, 0, 0, 1, 0] }
      piller_cop.set(Place["22"])
      piller_cop.set(Place["23"])
      piller_cop.set(Place["24"])
      piller_cop.set(Place["25"])
      piller_cop.set(Place["26"])
      piller_cop.set(Place["27"])
      piller_cop.set(Place["28"])
      assert { piller_cop.active == false }
      piller_cop.set(Place["29"])
      assert { piller_cop.counts == [0, 0, 0, 0, 0, 0, 0, 9, 0] }
      assert { piller_cop.active == true }
      piller_cop.remove(Place["29"])
      assert { piller_cop.active == false }
      assert { piller_cop.counts == [0, 0, 0, 0, 0, 0, 0, 8, 0] }
    end

    it "reset" do
      piller_cop = PillerCop.new
      piller_cop.set(Place["21"])
      piller_cop.active = true
      piller_cop.reset
      assert { piller_cop.counts == [0, 0, 0, 0, 0, 0, 0, 0, 0] }
      assert { piller_cop.active == false }
    end

    it "指定の列に駒がない状態で削除しようとしたのでエラーになる" do
      piller_cop = PillerCop.new
      expect { piller_cop.remove(Place["21"]) }.to raise_error(MustNotHappen)
    end

    it "指定の列が埋まっている状態でさらに置こうとしたのでエラーになる" do
      piller_cop = PillerCop.new
      Dimension::Row.dimension_size.times { piller_cop.set(Place["21"]) }
      expect { piller_cop.set(Place["21"]) }.to raise_error(MustNotHappen)
    end
  end
end
