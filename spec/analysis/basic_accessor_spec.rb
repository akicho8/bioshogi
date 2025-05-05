require "spec_helper"

RSpec.describe Bioshogi::Analysis::BasicAccessor do
  it "works" do
    assert { Bioshogi::Analysis::AttackInfo["棒銀"].only_preset_attr            == :hirate_like }
    assert { Bioshogi::Analysis::DefenseInfo["無敵囲い"].only_preset_attr       == :hirate_like }
    assert { Bioshogi::Analysis::DefenseInfo["銀多伝"].only_preset_attr         == :x_taden     }
    assert { Bioshogi::Analysis::TechniqueInfo["割り打ちの銀"].only_preset_attr == nil          }
    assert { Bioshogi::Analysis::NoteInfo["居飛車"].only_preset_attr            == nil          }
  end
end
