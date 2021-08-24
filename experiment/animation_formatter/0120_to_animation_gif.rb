require "../example_helper"
Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
info = Parser.parse("position startpos moves 7g7f 8c8d")

bin = info.to_animation_gif(one_frame_duration: 0.5, media_factory_key: "rmagick", tmpdir_remove: false)
Pathname("_output_rmagick.gif").write(bin) # => 33719
puts `identify _output_rmagick.gif`

bin = info.to_animation_gif(one_frame_duration: 0.5, media_factory_key: "ffmpeg", tmpdir_remove: false)
Pathname("_output.gif").write(bin) # => 44587
puts `identify _output.gif`

`open -a 'Google Chrome' _output.gif`

# >> [AnimationGifFormatter] cd /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210823-52638-3kgrrs
# >> [AnimationGifFormatter] 生成に使うもの: rmagick
# >> [AnimationGifFormatter] 最後に追加するフレーム数(end_frames): 0
# >> [AnimationGifFormatter] 1手当たりの秒数(one_frame_duration): 0.5
# >> [AnimationGifFormatter] move: 0 / 2
# >> [AnimationGifFormatter] ticks_per_second: 100
# >> [AnimationGifFormatter] delay: 50
# >> [AnimationGifFormatter] optimize_layers[begin]:
# >> [AnimationGifFormatter] optimize_layers[end 0s]:
# >> [AnimationGifFormatter] write[begin]:
# >> [AnimationGifFormatter] write[end 0s]:
# >> _output_rmagick.gif[0] GIF 1200x630 1200x630+0+0 8-bit sRGB 64c 0.000u 0:00.000
# >> _output_rmagick.gif[1] GIF 62x135 1200x630+446+348 8-bit sRGB 64c 0.000u 0:00.000
# >> _output_rmagick.gif[2] GIF 113x323 1200x630+384+148 8-bit sRGB 64c 33719B 0.000u 0:00.000
# >> [AnimationGifFormatter] cd /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210823-52638-kwss73
# >> [AnimationGifFormatter] 生成に使うもの: ffmpeg
# >> [AnimationGifFormatter] 最後に追加するフレーム数(end_frames): 0
# >> [AnimationGifFormatter] 1手当たりの秒数(one_frame_duration): 0.5
# >> [AnimationGifFormatter] move: 0 / 2
# >> [AnimationGifFormatter] 合計フレーム数(frame_count): 3
# >> [AnimationGifFormatter] ソース画像生成数: 3
# >> [AnimationGifFormatter] [execute] ffmpeg -v warning -hide_banner -framerate 1000/500 -i _input%03d.png  -y _output1.gif
# >> [AnimationGifFormatter] [execute] elapsed: 2s
# >> [AnimationGifFormatter] -rw-r--r-- 1 ikeda staff 44K  8 23 19:44 _output1.gif
# >> _output.gif[0] GIF 1200x630 1200x630+0+0 8-bit sRGB 256c 0.000u 0:00.000
# >> _output.gif[1] GIF 62x135 1200x630+446+348 8-bit sRGB 256c 0.000u 0:00.000
# >> _output.gif[2] GIF 124x335 1200x630+384+148 8-bit sRGB 256c 44587B 0.000u 0:00.000
