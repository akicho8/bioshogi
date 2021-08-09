require "../example_helper"
require "rmagick"

sfen = "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 8c8d 7g7f 7a6b 5g5f 8d8e 8h7g"
sfen = "position startpos moves 7g7f 8c8d 2g2f"
info = Parser.parse(sfen)

mediator = Mediator.new         # MediatorFast にする
mediator.params.update({
    :skill_monitor_enable           => false,
    :skill_monitor_technique_enable => false,
    :candidate_enable               => false,
    :validate_enable                => false,
  })
info.mediator_board_setup(mediator)
image_formatter = ImageFormatter.new(mediator, viewpoint: "black")
# puts mediator

list = Magick::ImageList.new
# list.ticks_per_second           # =>
# list.delay = list.ticks_per_second
image_formatter.render
list.concat([image_formatter.canvas])
info.move_infos.each.with_index(1) do |e, i|
  mediator.execute(e[:input])
  image_formatter.render
  list.concat([image_formatter.canvas])
  # puts image_formatter.to_tempfile
  # image_formatter.canvas.write("#{i}.gif")
end
@delay_per_one = 0.5            # 1枚を何秒で表示するか？
list.ticks_per_second           # => 100
list.delay = list.ticks_per_second * @delay_per_one

# list = list.coalesce            # 最小単位にしてあったら元のフレームサイズにする
# list = list.optimize_layers(Magick::OptimizeLayer) # 最小単位にする

# list.start_loop                 # => false
# list.start_loop = true          # => true
# list.start_loop                 # => true

# list.format = "png"
# list.to_blob[0...3]              # => 

list.write("_output.mov")       # => [_output.mov  1200x630 DirectClass 16-bit,

list.each.with_index do |e, i|
  e.write("_#{i}.png")
end
puts list.inspect # => nil

# puts mediator
# >> [_0.png  1200x630 DirectClass 16-bit 29kb,
# >> _1.png  1200x630 DirectClass 16-bit 30kb,
# >> _2.png  1200x630 DirectClass 16-bit 31kb,
# >> _3.png  1200x630 DirectClass 16-bit 33kb]
# >> scene=3
