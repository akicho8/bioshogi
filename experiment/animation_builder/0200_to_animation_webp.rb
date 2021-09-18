require "../example_helper"
Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
info = Parser.parse("position startpos moves 7g7f 8c8d")
bin = info.to_animation_webp(page_duration: 0.5)
Pathname("_output.webp").write(bin) # => 22522
puts `identify _output.webp`
`open -a 'Google Chrome' _output.webp`
# >> [AnimationWebpBuilder] cd /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210825-85804-1iibgt4
# >> [AnimationWebpBuilder] 生成に使うもの: ffmpeg
# >> [AnimationWebpBuilder] 最後に追加するフレーム数(end_pages): 0
# >> [AnimationWebpBuilder] 1手当たりの秒数(page_duration): 0.5
# >> [AnimationWebpBuilder] move: 0 / 2
# >> [AnimationWebpBuilder] 合計フレーム数(page_count): 3
# >> [AnimationWebpBuilder] ソース画像生成数: 3
# >> [AnimationWebpBuilder] [execute] ffmpeg -v warning -hide_banner -framerate 1000/500 -i _input%04d.png  -y _output1.webp
# >> [AnimationWebpBuilder] [execute] elapsed: 2s
# >> [AnimationWebpBuilder] [execute] stderr: [libwebp_anim @ 0x7fc2f7835200] Using libwebp for RGB-to-YUV conversion. You may want to consider passing in YUV instead for lossy encoding.
# >> 
# >> [AnimationWebpBuilder] -rw-r--r-- 1 ikeda staff 22K  8 25 18:02 _output1.webp
# >> [AnimationWebpBuilder] rm -fr /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210825-85804-1iibgt4
# >> _output.webp[0] WEBP 1200x630 1200x630+0+0 8-bit sRGB 22522B 0.010u 0:00.010
# >> _output.webp[1] WEBP 62x133 1200x630+446+350 8-bit sRGB 0.000u 0:00.001
# >> _output.webp[2] WEBP 122x335 1200x630+386+148 8-bit sRGB 0.000u 0:00.001
