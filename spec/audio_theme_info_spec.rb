require "spec_helper"

module Bioshogi
  describe AudioThemeInfo do
    it "works" do
      AudioThemeInfo.each do |e|
        assert { e.valid? }
      end
    end
  end
end
