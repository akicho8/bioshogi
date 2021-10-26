require "spec_helper"

module Bioshogi
  describe AkfBuilder do
    it "works" do
      assert { Parser.parse("68S").to_akf }
    end
  end
end
