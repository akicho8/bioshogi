require "spec_helper"

RSpec.describe do
  it "works" do
    assert { !Bioshogi::Parser.parse("58飛").to_kif.match?(/後手の備考：.*居飛車/) }
  end
end
