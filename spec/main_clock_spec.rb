require "spec_helper"

RSpec.describe Bioshogi::MainClock do
  it "Bioshogi::MainClock" do
    main_clock = Bioshogi::MainClock.new
    main_clock.add(1)
    main_clock.add(5)
    main_clock.add(1)
    assert { main_clock.to_s == "(00:01/00:00:02)" }
  end
end
