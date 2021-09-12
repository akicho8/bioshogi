require "../example_helper"

# SFEN = "position sfen l+n1g1g1n+l/1ks2r1+r1/1pppp1bpp/p2+b+sp+p2/9/P1P1+SP1PP/1+P+BPP1P2/1BK1GR1+R1/+L+NSG3NL b R2B3G4S5N11L99Pr2b3g4s5n11l99p 1"
# 
# def output(bin, name)
#   file = Pathname("#{__dir__}/../../demo/#{name}").expand_path
#   FileUtils.makedirs(file.dirname)
#   file.write(bin)
#   puts file
# end
# 
# parser = Parser.parse(SFEN)
# ImageRenderer::ColorThemeInfo.each do |e|
#   bin = parser.to_png(color_theme_key: e.key)
#   output(bin, "color_theme/#{'%02d' % e.code}_#{e.key}.png")
# end
# 
# ImageRenderer::CanvasPatternInfo.each do |e|
#   bin = e.execute.to_blob { |e| e.format = "png" }
#   output(bin, "canvas_pattern/#{'%02d' % e.code}_#{e.key}.png")
# end
