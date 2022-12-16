require "../setup"
info = Parser.parse(SFEN1)
ScreenImage::PieceFontWeightInfo.each do |e|
  info.screen_image_renderer(color_theme_key: "is_color_theme_wars_red", piece_font_weight_key: e.key).display
end
