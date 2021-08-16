require "../example_helper"

info = Parser.parse("position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 8c8d 7g7f")
bin = info.to_mp4(video_speed: 5.0)
Pathname("_output.mp4").write(bin) # => 279271
`open -a 'google chrome' _output.mp4`
# >> /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210816-2073-fuao7d
# >> ffmpeg -v warning -hide_banner -r 1000/5000 -y -i _output0.mp4 -c:v libx264 -pix_fmt yuv420p -y _output1_yuv420.mp4
# >> ffmpeg -v warning -stream_loop -1 -i /Users/ikeda/src/bioshogi/lib/bioshogi/loop_bgm.m4a -t 15.0 -af "afade=t=out:st=10.0:d=5" -y _fade.m4a
# >> 15.0
# >> ffmpeg -v warning -i _output1_yuv420.mp4 -i _fade.m4a -c copy -y _output2.mp4
