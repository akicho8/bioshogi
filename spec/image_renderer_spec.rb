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
    end

    it "color_theme_key" do
      renderer = target1(color_theme_key: "color_theme_is_real_wood1")
      assert { renderer.render }
    end

    it "全配色指定確認" do
      ImageRenderer::ColorThemeInfo.each do |e|
        assert { target1(color_theme_key: e.key).render }
      end
    end

    it "全フォント指定確認" do
      parser = Parser.parse(SFEN1)
      ImageRenderer::FontThemeInfo.each do |e|
        assert { target1(font_theme_key: e.key).render }
      end
    end
  end
end
