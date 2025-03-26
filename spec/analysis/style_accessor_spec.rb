require "spec_helper"

RSpec.describe Bioshogi::Analysis::StyleAccessor do
  it "works" do
    assert { Bioshogi::Analysis::DefenseInfo.styles_hash }
    assert { Bioshogi::Analysis::DefenseInfo["美濃囲い"].style_info.name == "王道"   }
    assert { Bioshogi::Analysis::DefenseInfo["美濃囲い"].frequency.kind_of?(Integer) }
  end
end
