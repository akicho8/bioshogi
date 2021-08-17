require "../example_helper"
Bioshogi.logger = ActiveSupport::Logger.new(STDOUT)
info = Parser.parse("position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 8c8d 7g7f")
bin = info.to_mp4(video_speed: 5.0)
Pathname("_output.mp4").write(bin) # => 279526
Media.duration("_output.mp4")      # => 15.0
Media.p("_output.mp4")
tp Media.format("_output.mp4")
# `open -a 'google chrome' _output.mp4`
# >> cd /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210817-77261-14pari5
# >> ffmpeg -v warning -hide_banner -r 1000/5000 -y -i _output0.mp4 -c:v libx264 -pix_fmt yuv420p -y _output1.mp4
# >> pid 77270 exit 0
# >> 2s
# >> audio_file: /Users/ikeda/src/bioshogi/lib/bioshogi/assets/audios/loop_bgm1.m4a
# >> ffmpeg -v warning -stream_loop -1 -i /Users/ikeda/src/bioshogi/lib/bioshogi/assets/audios/loop_bgm1.m4a -t 15.0 -af "afade=t=out:st=12.0:d=3.0" -y _same_lengh.m4a
# >> pid 77275 exit 0
# >> 1s
# >> loop_bgm1.m4a: 4.852971
# >> _same_lengh.m4a: 15.0
# >> ffmpeg -v warning -i _output1.mp4 -i _same_lengh.m4a -c copy -y _output2.mp4
# >> pid 77279 exit 0
# >> 1s
# >> rm -fr /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210817-77261-14pari5
# >>   Stream #0:0(und): Video: h264 (High) (avc1 / 0x31637661), yuv420p, 1200x630, 18 kb/s, 0.20 fps, 0.20 tbr, 16384 tbn, 0.40 tbc (default)
# >>   Stream #0:1(eng): Audio: aac (LC) (mp4a / 0x6134706D), 44100 Hz, stereo, fltp, 128 kb/s (default)
# >> |------------------+----------------------------------------------------------------------------------------------------------------------|
# >> |         filename | _output.mp4                                                                                                          |
# >> |       nb_streams | 2                                                                                                                    |
# >> |      nb_programs | 0                                                                                                                    |
# >> |      format_name | mov,mp4,m4a,3gp,3g2,mj2                                                                                              |
# >> | format_long_name | QuickTime / MOV                                                                                                      |
# >> |       start_time | 0:00:00.000000                                                                                                       |
# >> |         duration | 0:00:15.000000                                                                                                       |
# >> |             size | 272.974609 Kibyte                                                                                                    |
# >> |         bit_rate | 149.080000 Kbit/s                                                                                                    |
# >> |      probe_score | 100                                                                                                                  |
# >> |             tags | {"major_brand"=>"isom", "minor_version"=>"512", "compatible_brands"=>"isomiso2avc1mp41", "encoder"=>"Lavf58.76.100"} |
# >> |------------------+----------------------------------------------------------------------------------------------------------------------|
