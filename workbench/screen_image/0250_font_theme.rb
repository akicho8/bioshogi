require "../setup"

info = Parser.parse(SFEN1)
# ScreenImage::FontThemeInfo.each do |e|
#   info.screen_image_renderer(color_theme_key: "is_color_theme_paper", font_theme_key: e.key).display
#   info.screen_image_renderer(color_theme_key: "is_color_theme_paper", font_theme_key: e.key, soldier_font_bold: true).display
# end

info.screen_image_renderer(color_theme_key: "is_color_theme_real", font_theme_key: "mplus_rounded1c_sans", soldier_font_bold: true).display

# info.screen_image_renderer(color_theme_key: "is_color_theme_paper", font_theme_key: "ricty_sans").display
# info.screen_image_renderer(color_theme_key: "is_color_theme_paper", font_theme_key: "ricty_sans", soldier_font_bold: true).display
# info.screen_image_renderer(color_theme_key: "is_color_theme_paper", font_theme_key: "noto_seif").display
# info.screen_image_renderer(color_theme_key: "is_color_theme_paper", font_theme_key: "noto_seif", soldier_font_bold: true).display
