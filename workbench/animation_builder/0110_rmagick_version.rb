require "../setup"
require "rmagick"

sfen = "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 8c8d 7g7f 7a6b 5g5f 8d8e 8h7g"
sfen = "position startpos moves 7g7f 8c8d 2g2f"
info = Parser.parse(sfen)

container = Container::Basic.new         # Container::Fast にする
container.params.update({
    :analysis_feature          => false,
    :analysis_technique_feature => false,
    :ki2_function              => false,
    :validate_feature           => false,
  })
info.formatter.container_init(container)
screen_image_renderer = ScreenImage.renderer(container, viewpoint: "black")
# puts container

list = Magick::ImageList.new
# list.ticks_per_second           # =>
# list.delay = list.ticks_per_second
screen_image_renderer.render
list.concat([screen_image_renderer.canvas])
info.pi.move_infos.each.with_index(1) do |e, i|
  container.execute(e[:input])
  screen_image_renderer.render
  list.concat([screen_image_renderer.canvas])
  # puts screen_image_renderer.to_tempfile
  screen_image_renderer.canvas.write("_#{i}.gif")
end

@page_duration = 0.5            # 1枚を何秒で表示するか？
# list.ticks_per_second = 2          # => 2
list.ticks_per_second              # => 100
list.delay                      # => 0
list.delay = list.ticks_per_second * @page_duration
# list.delay = 0

list = list.coalesce            # 最小単位にしてあったら元のフレームサイズにする
list = list.optimize_layers(Magick::OptimizeLayer) # 最小単位にする

# list.start_loop                 # => false
# list.start_loop = true          # => true
# list.start_loop                 # => true

# list.format = "png"
# list.ticks_per_second           # => 100
# list.to_blob[0...3]              # =>

list.format = "png"
Pathname("_a.png").binwrite(list.to_blob)
puts `identify _a.png`

puts list.inspect

# list.write("_output.mp4")       # => [_output.mp4  1200x630 1200x630+0+0 PseudoClass 33c 16-bit,
list.write("_output.png")       # => [_output-0.png PNG 1200x630 1200x630+0+0 PseudoClass 32c 16-bit 34kb,

puts list.inspect # => nil
list.each.with_index do |e, i|
  e.write("_#{i}.png")
end

# puts container
# >> _a.png PNG 1200x630 1200x630+0+0 16-bit Grayscale Gray 35105B 0.000u 0:00.000
# >> [ PNG 1200x630 1200x630+0+0 PseudoClass 32c 16-bit 34kb,
# >> _3.gif  1x1 1200x630+-1+-1 PseudoClass 33c 16-bit,
# >> _3.gif  1x1 1200x630+-1+-1 PseudoClass 33c 16-bit,
# >> _3.gif  1x1 1200x630+-1+-1 PseudoClass 33c 16-bit]
# >> scene=0
# >> [_output-0.png PNG 1200x630 1200x630+0+0 PseudoClass 32c 16-bit 34kb,
# >> _output-1.png  1x1 1200x630+-1+-1 PseudoClass 2c 8-bit 183b,
# >> _output-2.png  1x1 1200x630+-1+-1 PseudoClass 2c 8-bit 183b,
# >> _output-3.png  1x1 1200x630+-1+-1 PseudoClass 2c 8-bit 183b]
# >> scene=0
