require "spec_helper"

module Bioshogi
  module Formatter
    describe AkfBuilder do
      it "works" do
        assert { Parser.parse("68S").to_akf }
      end
    end
  end
end
