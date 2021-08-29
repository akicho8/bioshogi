require "../example_helper"

def test(key)
  e = ImageFormatter::CanvasPatternInfo.fetch(key)
  bin = e.execute.to_blob { |e| e.format = "png" }
  file = Pathname("_#{'%02d' % e.code}_#{e.key}.png").expand_path
  file.write(bin)
  `open #{file}`
end

# test(:pattern_checker_light)
test(:pattern_checker_dark)
