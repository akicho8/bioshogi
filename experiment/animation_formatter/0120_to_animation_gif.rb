require "../example_helper"
Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
info = Parser.parse("position startpos moves 7g7f 8c8d")

bin = info.to_animation_gif(one_frame_duration: 0.5, mp4_factory_key: "rmagick", tmpdir_remove: false)
Pathname("_output_rmagick.gif").write(bin) # => 33719
puts `identify _output_rmagick.gif`

bin = info.to_animation_gif(one_frame_duration: 0.5, mp4_factory_key: "ffmpeg", tmpdir_remove: false)
Pathname("_output.gif").write(bin) # => 44587
puts `identify _output.gif`

# `open -a 'Google Chrome' _output.gif`

# >> [animation_gif_formatter] cd /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210823-35680-1cgftuw
# >> [animation_gif_formatter] 生成に使うもの: rmagick
# >> [animation_gif_formatter] 最後に追加するフレーム数(end_frames): 0
# >> [animation_gif_formatter] 1手当たりの秒数(one_frame_duration): 0.5
# >> [animation_gif_formatter] move: 0 / 2
# >> [animation_gif_formatter] ticks_per_second: 100
# >> [animation_gif_formatter] delay: 50
# >> [animation_gif_formatter] optimize_layers[begin]
# >> [animation_gif_formatter] optimize_layers[end]
# >> [animation_gif_formatter] write[begin]: _output1.gif
# >> [animation_gif_formatter] write[end]: _output1.gif
# >> _output_rmagick.gif[0] GIF 1200x630 1200x630+0+0 8-bit sRGB 64c 0.000u 0:00.000
# >> _output_rmagick.gif[1] GIF 62x135 1200x630+446+348 8-bit sRGB 64c 0.000u 0:00.000
# >> _output_rmagick.gif[2] GIF 113x323 1200x630+384+148 8-bit sRGB 64c 33719B 0.000u 0:00.000
# >> [animation_gif_formatter] cd /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210823-35680-o7obze
# >> [animation_gif_formatter] 生成に使うもの: ffmpeg
# >> [animation_gif_formatter] 最後に追加するフレーム数(end_frames): 0
# >> [animation_gif_formatter] 1手当たりの秒数(one_frame_duration): 0.5
# >> [animation_gif_formatter] move: 0 / 2
# >> [animation_gif_formatter] 合計フレーム数(frame_count): 3
# >> [animation_gif_formatter] ソース画像生成数: 3
# >> [animation_gif_formatter] write[begin]: _output1.gif
# >> [animation_gif_formatter] [execute] ffmpeg -v warning -hide_banner -framerate 1000/500 -i _input%03d.png -y _output1.gif
# >> [animation_gif_formatter] [execute] elapsed: 2s
# >> [animation_gif_formatter] write[end]: _output1.gif
# >> [animation_gif_formatter] -rw-r--r-- 1 ikeda staff 44K  8 23 17:32 _output1.gif
# >> _output.gif[0] GIF 1200x630 1200x630+0+0 8-bit sRGB 256c 0.000u 0:00.000
# >> _output.gif[1] GIF 62x135 1200x630+446+348 8-bit sRGB 256c 0.000u 0:00.000
# >> _output.gif[2] GIF 124x335 1200x630+384+148 8-bit sRGB 256c 44587B 0.000u 0:00.000
