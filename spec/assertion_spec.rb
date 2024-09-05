require "spec_helper"

module Bioshogi
  describe Assertion do
    it "works" do
      assert { Assertion.assert(false) rescue $!.message == "assert failed: false" }
      assert { Assertion.assert_equal(0, 1) rescue $!.message == "assert_equal failed: 0 != 1" }
    end
  end
end
