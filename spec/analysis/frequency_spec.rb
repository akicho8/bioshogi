require "spec_helper"

RSpec.describe Bioshogi::Analysis::Frequency do
  it "works" do
    assert { Bioshogi::Analysis::Frequency[:attack][:"2手目△3二銀システム"] }
  end
end
