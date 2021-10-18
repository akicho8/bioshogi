require "../setup"
info = Parser.parse(SFEN1)
ImageRenderer::XboldInfo.each do |e|
  info.image_renderer(color_theme_key: "is_color_theme_wars_red", xbold_key: e.key).display
end
