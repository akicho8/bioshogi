require "../example_helper"
Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
info = Parser.parse("position startpos moves 7g7f 8c8d")
bin = info.to_animation_apng(page_duration: 0.5)
Pathname("_output.apng").write(bin) # => 38007
puts `identify _output.apng`
`open -a 'Google Chrome' _output.apng`
# >> [AnimationPngBuilder] cd /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210824-79365-d4caky
# >> [AnimationPngBuilder] 生成に使うもの: ffmpeg
# >> [AnimationPngBuilder] 最後に追加するフレーム数(end_pages): 0
# >> [AnimationPngBuilder] 1手当たりの秒数(page_duration): 0.5
# >> [AnimationPngBuilder] move: 0 / 2
# >> [AnimationPngBuilder] 合計フレーム数(page_count): 3
# >> [AnimationPngBuilder] ソース画像生成数: 3
# >> [AnimationPngBuilder] [execute] ffmpeg -v warning -hide_banner -framerate 1000/500 -i _input%04d.png  -y _output1.apng
# >> [AnimationPngBuilder] [execute] elapsed: 5s
# >> [AnimationPngBuilder] -rw-r--r-- 1 ikeda staff 38K  8 24 06:43 _output1.apng
# >> [AnimationPngBuilder] rm -fr /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210824-79365-d4caky
# >> _output.apng PNG 1200x630 1200x630+0+0 16-bit Grayscale Gray 38007B 0.000u 0:00.000
