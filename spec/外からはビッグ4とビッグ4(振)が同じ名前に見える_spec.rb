require "spec_helper"

RSpec.describe __FILE__ do
  xit "works" do
    info = Bioshogi::DefenseInfo.fetch("ビッグ4(振)").static_kif_info
    assert { info.formatter.container.player_at(:black).defense_infos.collect(&:name) == ["ビッグ4"] }
    assert { info.to_kif.match?(/^先手の囲い：ビッグ4$/) }
  end
end
