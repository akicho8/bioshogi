require "spec_helper"
require_relative "test_methods"

RSpec.describe Bioshogi::ScreenImage::PieceFontWeightInfo, screen_image: true do
  describe "全パターン確認" do
    Bioshogi::ScreenImage::PieceFontWeightInfo.each do |e|
      it e.key do
        assert { target1(piece_font_weight_key: e.key).render }
      end
    end
  end
end
