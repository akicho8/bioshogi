require "spec_helper"

module Bioshogi
  module Yomiage
    describe KanjiInfo do
      it "works" do
        assert { KanjiInfo.fetch("不成") }
      end
    end
  end
end
