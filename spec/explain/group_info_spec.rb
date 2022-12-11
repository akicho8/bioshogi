require "spec_helper"

module Bioshogi
  module Explain
    describe GroupInfo do
      it "values" do
        assert { GroupInfo.fetch("右玉").values.count === 9 }
      end
    end
  end
end
