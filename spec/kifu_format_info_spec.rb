require "spec_helper"

module Bioshogi
  describe do
    it "works" do
      assert { KifuFormatInfo[:kif].name == "KIF" }
    end
  end
end
