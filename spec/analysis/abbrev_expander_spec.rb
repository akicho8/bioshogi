require "spec_helper"

RSpec.describe Bioshogi::Analysis::AbbrevExpander do
  it "works" do
    assert { Bioshogi::Analysis::AbbrevExpander.expand("向飛車")     == ["向飛車", "向かい飛車", "向飛車戦法", "向飛車囲い", "向飛車流", "向飛車型"]     }
    assert { Bioshogi::Analysis::AbbrevExpander.expand("向飛車戦法") == ["向飛車戦法", "向かい飛車戦法", "向飛車囲い", "向飛車流", "向飛車型", "向飛車"] }
  end
end
