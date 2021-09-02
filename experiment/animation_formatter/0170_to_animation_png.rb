require "../example_helper"
Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
info = Parser.parse("position startpos moves 7g7f 8c8d")
bin = info.to_animation_png(one_frame_duration_sec: 0.5)
Pathname("_output.apng").write(bin) # => 38007
puts `identify _output.apng`
`open -a 'Google Chrome' _output.apng`
# >> [AnimationPngFormatter] cd /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210824-79365-d4caky
# >> [AnimationPngFormatter] 生成に使うもの: ffmpeg
# >> [AnimationPngFormatter] 最後に追加するフレーム数(end_frames): 0
# >> [AnimationPngFormatter] 1手当たりの秒数(one_frame_duration_sec): 0.5
# >> [AnimationPngFormatter] move: 0 / 2
# >> [AnimationPngFormatter] 合計フレーム数(frame_count): 3
# >> [AnimationPngFormatter] ソース画像生成数: 3
# >> [AnimationPngFormatter] [execute] ffmpeg -v warning -hide_banner -framerate 1000/500 -i _input%04d.png  -y _output1.apng
# >> [AnimationPngFormatter] [execute] elapsed: 5s
# >> [AnimationPngFormatter] -rw-r--r-- 1 ikeda staff 38K  8 24 06:43 _output1.apng
# >> [AnimationPngFormatter] rm -fr /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210824-79365-d4caky
# >> _output.apng PNG 1200x630 1200x630+0+0 16-bit Grayscale Gray 38007B 0.000u 0:00.000
