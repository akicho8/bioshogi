require_relative "spec_helper"

module Bioshogi
  describe do
    it "works" do
      info = Parser.parse("position sfen 3skg3/R8/9/9/9/9/9/9/9 b 2R2B3g3s4n4l18p 1")
      assert { info.to_yomiage == "gyokugata。きゅうにぃひしゃ。せめかた。ごーいちぎょく。よんいちきん。ろくいちぎん。もちごま。ひしゃ。ひしゃ。かく。かく。" }
    end
  end
end
