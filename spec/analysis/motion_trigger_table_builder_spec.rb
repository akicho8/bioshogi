require "spec_helper"

RSpec.describe Bioshogi::Analysis::MotionTriggerTableBuilder do
  it "build" do
    assert { Bioshogi::Analysis::MotionTriggerTableBuilder.new.build }
  end
end
