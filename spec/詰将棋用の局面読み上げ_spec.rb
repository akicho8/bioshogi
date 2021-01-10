require_relative "spec_helper"

module Bioshogi
  describe do
    it "works" do
      info = Parser.parse("position sfen 4k4/9/4G4/9/9/9/9/9/9 b 2G2r2b2g4s4n4l18p 1")
      assert { info.to_yomiage == "gyokugata。ごーいちgyoku。せめかた。ごーさんkin。もちごま。kin。kin。" }
    end
  end
end
