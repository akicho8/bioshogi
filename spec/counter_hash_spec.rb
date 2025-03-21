require "spec_helper"

describe Bioshogi::CounterHash do
  it "works" do
    h = Bioshogi::CounterHash.new
    assert { h[:x] ==  0 }
    h.increment(:x)
    assert { h.keys == [:x] }
    h.decrement(:x)
    assert { h.keys ==  [] }
    assert { h.count ==  0 }
  end
end
