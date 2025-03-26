require "spec_helper"
require_relative "test_methods"

RSpec.describe Bioshogi::ScreenImage::FontThemeInfo, screen_image: true do
  describe "全パターン確認" do
    Bioshogi::ScreenImage::FontThemeInfo.each do |e|
      it e.key do
        assert { target1(font_theme_key: e.key).render }
      end
    end
  end
end
