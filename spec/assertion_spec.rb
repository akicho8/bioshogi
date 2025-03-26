require "spec_helper"

RSpec.describe Bioshogi::Assertion do
  it "assert" do
    expect { Bioshogi::Assertion.assert(false) }.to raise_error(Bioshogi::MustNotHappen)
  end
  it "assert_equal" do
    expect { Bioshogi::Assertion.assert_equal(true, false) }.to raise_error(Bioshogi::MustNotHappen)
  end
end
