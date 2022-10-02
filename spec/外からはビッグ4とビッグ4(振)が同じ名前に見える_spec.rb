require "spec_helper"

module Bioshogi
  describe do
    xit "works" do
      info = DefenseInfo.fetch("ビッグ4(振)").sample_kif_info
      assert { info.xcontainer.player_at(:black).defense_infos.collect(&:name) == ["ビッグ4"] }
      assert { info.to_kif.match?(/^先手の囲い：ビッグ4$/) }
    end
  end
end
