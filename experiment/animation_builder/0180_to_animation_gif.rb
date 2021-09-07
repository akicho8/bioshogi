require "../example_helper"
Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
info = Parser.parse("position startpos moves 7g7f 8c8d")

bin = info.to_animation_gif(one_frame_duration_sec: 0.5, media_factory_key: "rmagick", tmpdir_remove: false)
Pathname("_output_rmagick.gif").write(bin) # => 33701
puts `identify _output_rmagick.gif`

bin = info.to_animation_gif(one_frame_duration_sec: 0.5, media_factory_key: "ffmpeg", tmpdir_remove: false)
Pathname("_output.gif").write(bin) # => 44549
puts `identify _output.gif`

`open -a 'Google Chrome' _output.gif`

# >> [AnimationGifBuilder] cd /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210825-85059-75npfc
# >> [AnimationGifBuilder] 生成に使うもの: rmagick
# >> [AnimationGifBuilder] 最後に追加するフレーム数(end_frames): 0
# >> [AnimationGifBuilder] 1手当たりの秒数(one_frame_duration_sec): 0.5
# >> [AnimationGifBuilder] move: 0 / 2
# >> [AnimationGifBuilder] ticks_per_second: 100
# >> [AnimationGifBuilder] delay: 50
# >> [AnimationGifBuilder] optimize_layers[begin]: 
# >> [AnimationGifBuilder] optimize_layers[end 0s]: 
# >> [AnimationGifBuilder] write[begin]: 
# >> [AnimationGifBuilder] write[end 0s]: 
# >> _output_rmagick.gif[0] GIF 1200x630 1200x630+0+0 8-bit sRGB 64c 0.000u 0:00.000
# >> _output_rmagick.gif[1] GIF 62x135 1200x630+446+348 8-bit sRGB 64c 0.000u 0:00.000
# >> _output_rmagick.gif[2] GIF 113x323 1200x630+384+148 8-bit sRGB 64c 33701B 0.000u 0:00.000
# >> [AnimationGifBuilder] cd /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210825-85059-1hknfsr
# >> [AnimationGifBuilder] 生成に使うもの: ffmpeg
# >> [AnimationGifBuilder] 最後に追加するフレーム数(end_frames): 0
# >> [AnimationGifBuilder] 1手当たりの秒数(one_frame_duration_sec): 0.5
# >> [AnimationGifBuilder] move: 0 / 2
# >> [AnimationGifBuilder] 合計フレーム数(frame_count): 3
# >> [AnimationGifBuilder] ソース画像生成数: 3
# >> [AnimationGifBuilder] [execute] ffmpeg -v warning -hide_banner -framerate 1000/500 -i _input%04d.png  -y _output1.gif
# >> [AnimationGifBuilder] [execute] elapsed: 2s
# >> [AnimationGifBuilder] -rw-r--r-- 1 ikeda staff 44K  8 25 17:58 _output1.gif
# >> _output.gif[0] GIF 1200x630 1200x630+0+0 8-bit sRGB 256c 0.000u 0:00.000
# >> _output.gif[1] GIF 62x135 1200x630+446+348 8-bit sRGB 256c 0.000u 0:00.000
# >> _output.gif[2] GIF 124x335 1200x630+384+148 8-bit sRGB 256c 44549B 0.000u 0:00.000
