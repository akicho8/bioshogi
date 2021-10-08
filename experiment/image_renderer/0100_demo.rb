require "../example_helper"

def output(bin, name)
  file = Pathname("#{__dir__}/../../demo/#{name}").expand_path
  FileUtils.makedirs(file.dirname)
  file.write(bin)
  puts file
end

parser = Parser.parse(SFEN1)
ImageRenderer::ColorThemeInfo.each do |e|
  bin = parser.to_png(color_theme_key: e.key, width: 1920, height: 1080, soldier_font_bold: true, stand_piece_font_bold: true)
  output(bin, "color_theme/#{e.key}.png")
end

ImageRenderer::CanvasPatternInfo.each do |e|
  bin = e.execute.to_blob { |e| e.format = "png" }
  output(bin, "canvas_pattern/#{e.key}.png")
end
