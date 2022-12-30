require "spec_helper"

module Bioshogi
  module Yomiage
    describe NumberInfo do
      it "works" do
        assert { NumberInfo.fetch("1") }
      end
    end
  end
end
