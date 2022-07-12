require "../setup"

parser = Parser.parse(SFEN1)
ImageRenderer::ColorThemeInfo.each do |e|
  bin = parser.to_png(color_theme_key: e.key, width: 1920, height: 1080)
  file = Pathname("#{__dir__}/../../demo/color_theme/#{e.key}.png").expand_path
  FileUtils.makedirs(file.dirname)
  file.write(bin)
  puts file
end
