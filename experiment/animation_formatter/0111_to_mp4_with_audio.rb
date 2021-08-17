require "../example_helper"
Bioshogi.logger = ActiveSupport::Logger.new(STDOUT)
sfen = "position startpos moves 7g7f 8c8d 2g2f 4a3b 6i7h 8d8e 8h7g 3c3d 7i6h 2b7g+ 6h7g 3a2b 3i3h 7a6b 3g3f 2b3c 4g4f 6c6d 5i6h 6b6c 2i3g 5a4b 3h4g 7c7d 4i4h 8a7c 2h2i 8b8a 6g6f 6a6b 4g5f 9c9d 9g9f 1c1d 1g1f 6c5d 6h7i 5d6c 7i8h 6c5d 2f2e 5d6c 5f6g 6c5d 5g5f 4c4d 2i5i 4b3a 5f5e 5d4c 6g5f 3a2b 5i6i 2b3a 6i2i 3a2b 4f4e 4d4e 5f4e 8e8f 8g8f P*8e 8f8e 9d9e 9f9e 7d7e 7f7e 6d6e B*7f 6b5b 7g8f 6e6f 8i7g P*4d 4e5f 3d3e 3f3e 7c8e 7g8e P*3f 3g4e 4d4e P*6d N*7b 6d6c+ 5b6c 7f4c+ 3b4c S*5b B*7f 7h7g P*8g 7g8g B*6g 5f6g 7f8g+ 8h8g 6f6g+ B*8i 6g6f 5b4c+ G*7f 8g8h 7f8f 8h7i 8f7g P*6h S*6g 8i6g 6f6g 4c3c 2b3c S*3d 3c4d B*2b S*3c 3d3c 4d5e 3c3b 5e6d N*7f 7g7f 6h6g B*4f S*5g N*5e S*5f 8a8e 5g4f S*7h 7i7h 5e6g+ 5f6g 8e8g+ 7h7i 7f6g 2b5e+ 6d7e G*6e 7e8e N*7g 8e7f 6e7e 7f7e 5e6e 7e8d 6e8g S*6h 7i8i 6h7g+ R*8a N*8c P*8e 8d7c P*7d"
sfen = "position startpos moves 7g7f 3c3d 8h2b+ 8c8d 2b3a 8d8e 3a2a 8e8f 2a1a 8f8g+ 1a2a 8g8h"
info = Parser.parse(sfen)
bin = info.to_mp4(video_speed: 0.5, tmpdir_remove: false, acrossfade_duration: 1)
Pathname("_output.mp4").write(bin) # => 508596
Media.duration("_output.mp4")      # => 26.03
Media.p("_output.mp4")
tp Media.format("_output.mp4")
`open -a 'google chrome' _output.mp4`
# >> cd /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210817-3567-1lzzdny
# >> move: 1 / 12
# >> move: 11 / 12
# >> frame_count: 13
# >> video_speed: 2.0
# >> total_d: 26.0
# >> switch_turn: 5
# >> run: ffmpeg -v warning -hide_banner -r 1000/2000 -y -i _output0.mp4 -c:v libx264 -pix_fmt yuv420p -y _output1.mp4
# >> elapsed: 2s
# >> run: ffmpeg -v warning -stream_loop -1 -i /Users/ikeda/src/bioshogi/lib/bioshogi/assets/audios/loop_bgm1.m4a -t 10.0 -c copy -y _part1.m4a
# >> elapsed: 1s
# >> _part1.m4a: 10.007
# >> run: ffmpeg -v warning -stream_loop -1 -i /Users/ikeda/src/bioshogi/lib/bioshogi/assets/audios/loop_bgm2.m4a -t 16.0 -c copy -y _part2.m4a
# >> elapsed: 1s
# >> _part2.m4a: 16.021
# >> run: ffmpeg -v warning -i _part1.m4a -i _part2.m4a -filter_complex "concat=n=2:v=0:a=1" _concat.m4a
# >> elapsed: 1s
# >> run: ffmpeg -v warning -i _concat.m4a -af "afade=t=out:st=23.0:d=3.0" _same_lengh.m4a
# >> elapsed: 1s
# >> _same_lengh.m4a: 26.03
# >> run: ffmpeg -v warning -i _output1.mp4 -i _same_lengh.m4a -c copy -y _output2.mp4
# >> elapsed: 1s
# >>   Stream #0:0(und): Video: h264 (High) (avc1 / 0x31637661), yuv420p, 1200x630, 25 kb/s, 0.50 fps, 0.50 tbr, 16384 tbn, 1 tbc (default)
# >>   Stream #0:1(und): Audio: aac (LC) (mp4a / 0x6134706D), 44100 Hz, stereo, fltp, 128 kb/s (default)
# >> |------------------+----------------------------------------------------------------------------------------------------------------------|
# >> |         filename | _output.mp4                                                                                                          |
# >> |       nb_streams | 2                                                                                                                    |
# >> |      nb_programs | 0                                                                                                                    |
# >> |      format_name | mov,mp4,m4a,3gp,3g2,mj2                                                                                              |
# >> | format_long_name | QuickTime / MOV                                                                                                      |
# >> |       start_time | 0:00:00.000000                                                                                                       |
# >> |         duration | 0:00:26.030000                                                                                                       |
# >> |             size | 496.675781 Kibyte                                                                                                    |
# >> |         bit_rate | 156.310000 Kbit/s                                                                                                    |
# >> |      probe_score | 100                                                                                                                  |
# >> |             tags | {"major_brand"=>"isom", "minor_version"=>"512", "compatible_brands"=>"isomiso2avc1mp41", "encoder"=>"Lavf58.76.100"} |
# >> |------------------+----------------------------------------------------------------------------------------------------------------------|
