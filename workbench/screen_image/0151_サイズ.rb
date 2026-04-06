require "../setup"
[
  { width: 1200, height: 1600, master_scale: 0.8 },
  { width: 1080, height: 1080, master_scale: 0.8 },
  { width: 1600, height: 900,  master_scale: 1.0 },
  { width: 1200, height: 1350, master_scale: 0.8 },
].each do |options|
  parser = Parser.parse(SFEN1)
  object = parser.screen_image_renderer(options)
  object.display
end
# >> /Users/ikeda/src/shogi/bioshogi/workbench/tmp/50bc1eaf5fec8eed8b89d17d6ceae586.png
# >> /Users/ikeda/src/shogi/bioshogi/workbench/tmp/2057211c880be2959090e7d782df693d.png
# >> /Users/ikeda/src/shogi/bioshogi/workbench/tmp/c55a9b4b6d41544fb05e5a790e8e0cf5.png
# >> /Users/ikeda/src/shogi/bioshogi/workbench/tmp/0ca1fd05b0df83f15c7bd761d4fe47af.png
