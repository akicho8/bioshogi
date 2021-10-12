require "spec_helper"

module Bioshogi
  describe ImageRenderer do
    def target1(params = {})
      parser = Parser.parse(SFEN1)
      parser.image_renderer(width: 2, height: 2, **params)
    end

    it "render" do
      renderer = target1
      assert { renderer.render }
      assert { renderer.to_blob_binary[1..3] == "PNG" }
      assert { renderer.to_write_binary[1..3] == "PNG" }
      assert { renderer.to_png24_binary[1..3] == "PNG" }
    end

    it "color_theme_key" do
      renderer = target1(color_theme_key: "is_color_theme_real_wood1")
      assert { renderer.render }
    end

    describe "全配色指定確認" do
      ImageRenderer::ColorThemeInfo.each do |e|
        it e.key do
          assert { target1(color_theme_key: e.key).render }
        end
      end
    end

    describe "全フォント指定確認" do
      ImageRenderer::FontThemeInfo.each do |e|
        it e.key do
          assert { target1(font_theme_key: e.key).render }
        end
      end
    end
  end
end
