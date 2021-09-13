require "../example_helper"

info = Parser.parse(SFEN1)
# ImageRenderer::FontThemeInfo.each do |e|
#   info.image_renderer(color_theme_key: "color_theme_is_paper_simple", font_theme_key: e.key).display
#   info.image_renderer(color_theme_key: "color_theme_is_paper_simple", font_theme_key: e.key, soldier_font_bold: true).display
# end

info.image_renderer(color_theme_key: "color_theme_is_real_wood1", font_theme_key: "mplus_rounded1c_sans", soldier_font_bold: true).display

# info.image_renderer(color_theme_key: "color_theme_is_paper_simple", font_theme_key: "ricty_sans").display
# info.image_renderer(color_theme_key: "color_theme_is_paper_simple", font_theme_key: "ricty_sans", soldier_font_bold: true).display
# info.image_renderer(color_theme_key: "color_theme_is_paper_simple", font_theme_key: "noto_seif").display
# info.image_renderer(color_theme_key: "color_theme_is_paper_simple", font_theme_key: "noto_seif", soldier_font_bold: true).display

