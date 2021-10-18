require "spec_helper"

module Bioshogi
  describe ImageRenderer, animation: true do
    def target1(params = {})
      parser = Parser.parse(XK::SFEN1)
      parser.image_renderer(width: 2, height: 2, **params)
    end

    it "render" do
      renderer = target1
      assert { renderer.render }
      assert { renderer.to_blob_binary[1..3] == "PNG" }
      assert { renderer.to_write_binary[1..3] == "PNG" }
      assert { renderer.to_png24_binary[1..3] == "PNG" }
    end

    describe "配色" do
      it "color_theme_key" do
        renderer = target1(color_theme_key: "is_color_theme_groovy_board_texture1")
        assert { renderer.render }
      end

      it "存在しないキーになったときエラーにしない" do
        renderer = target1(color_theme_key: "(unknown)")
        assert { renderer.render }
      end

      describe "全パターン確認" do
        ImageRenderer::ColorThemeInfo.each do |e|
          it e.key do
            assert { target1(color_theme_key: e.key).render }
          end
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

    describe "XboldInfo全パターン確認" do
      ImageRenderer::XboldInfo.each do |e|
        it e.key do
          assert { target1(xbold_key: e.key).render }
        end
      end
    end
  end
end
