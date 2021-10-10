require "../setup"
parser = Parser.parse(SFEN1)
ms = Benchmark.ms do
  parser.image_renderer(color_theme_key: "is_color_theme_real_wood1", renderer_override_params: {:fg_file => "#{__dir__}/../../lib/bioshogi/assets/images/board/board_texture1.png"}).display
end
p "%.1f ms" % ms                  # => "1570.5 ms"
