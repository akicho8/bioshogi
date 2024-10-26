require "spec_helper"

module Bioshogi
  module Analysis
    describe GroupInfo do
      it "values" do
        assert { GroupInfo.fetch("右玉").values.collect(&:key).include?(:"雁木右玉") }
      end
    end
  end
end
