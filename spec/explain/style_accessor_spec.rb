require "spec_helper"

module Bioshogi
  module Explain
    describe StyleAccessor do
      it "works" do
        assert { DefenseInfo.styles_hash }
        assert { DefenseInfo["美濃囲い"].style_info.name == "王道"   }
        assert { DefenseInfo["美濃囲い"].frequency.kind_of?(Integer) }
      end
    end
  end
end
