require "spec_helper"

RSpec.describe Bioshogi::Analysis::BasicAccessor do
  it "works" do
    assert { Bioshogi::Analysis::AttackInfo["棒銀"].preset_has            == :hirate_like }
    assert { Bioshogi::Analysis::DefenseInfo["無敵囲い"].preset_has       == :hirate_like }
    assert { Bioshogi::Analysis::DefenseInfo["銀多伝"].preset_has         == :x_taden     }
    assert { Bioshogi::Analysis::TechniqueInfo["割り打ちの銀"].preset_has == nil          }
    assert { Bioshogi::Analysis::NoteInfo["居飛車"].preset_has            == nil          }
  end
end
