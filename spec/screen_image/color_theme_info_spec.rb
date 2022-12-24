require "spec_helper"
require_relative "test_methods"

module Bioshogi
  module ScreenImage
    describe ColorThemeInfo, screen_image: true do
      it "color_theme_key" do
        renderer = target1(color_theme_key: "is_color_theme_real")
        assert { renderer.render }
      end

      it "存在しないキーになったときエラーにしない" do
        renderer = target1(color_theme_key: "(unknown)")
        assert { renderer.render }
      end

      describe "全パターン確認" do
        ColorThemeInfo.each do |e|
          it e.key do
            assert { target1(color_theme_key: e.key).render }
          end
        end
      end
    end
  end
end
