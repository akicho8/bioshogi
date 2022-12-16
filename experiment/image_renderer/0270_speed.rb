require "../setup"
parser = Parser.parse(SFEN1)
ms = Benchmark.ms do
  parser.image_renderer(color_theme_key: "is_color_theme_real", renderer_override_params: {:fg_file => "#{ASSETS_DIR}/images/board/board_texture1.png"}).display
end
p "%.1f ms" % ms                  # => "1570.5 ms"
