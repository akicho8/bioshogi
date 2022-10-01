require "spec_helper"

module Bioshogi
  describe do
    it "works" do
      info = DefenseInfo.fetch("ビッグ４(振)").sample_kif_info
      assert { info.xcontainer.player_at(:black).defense_infos.collect(&:name) == ["ビッグ４"] }
      assert { info.to_kif.match?(/^先手の囲い：ビッグ４$/) }
    end
  end
end
