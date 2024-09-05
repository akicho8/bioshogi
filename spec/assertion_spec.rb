require "spec_helper"

module Bioshogi
  RSpec.describe Assertion do
    it "assert" do
      expect { Assertion.assert(false) }.to raise_error(MustNotHappen)
    end
    it "assert_equal" do
      expect { Assertion.assert_equal(true, false) }.to raise_error(MustNotHappen)
    end
  end
end
