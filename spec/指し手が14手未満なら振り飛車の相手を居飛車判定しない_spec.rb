require "spec_helper"

module Bioshogi
  RSpec.describe do
    it "works" do
      assert { !Parser.parse("58飛").to_kif.match?(/後手の備考：.*居飛車/) }
    end
  end
end
