require "spec_helper"

module Bioshogi
  describe CounterHash do
    it "works" do
      h = CounterHash.new
      assert { h[:x] ==  0 }
      h.increment(:x)
      assert { h.keys == [:x] }
      h.decrement(:x)
      assert { h.keys ==  [] }
      assert { h.count ==  0 }
    end
  end
end
