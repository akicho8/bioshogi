require "../example_helper"
Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

def test(video_crf, video_bit_rate, audio_bit_rate)
  info = Parser.parse("position startpos")
  bin = info.to_animation_mp4({
      :page_duration => 1,
      :end_duration       => 5,
      :audio_theme_key        => "audio_theme_is_headspin_only",
      :video_crf              => video_crf,
      :video_bit_rate         => video_bit_rate, # default は 200k とネットにはあるが実際は 68k ぐらいじゃない？
      :audio_bit_rate         => audio_bit_rate, # default: 128k
    })
  Pathname("_output.mp4").write(bin) # => 164787, 164787
  [
    Media.video_bit_rate("_output.mp4"),
    Media.audio_bit_rate("_output.mp4"),
  ].join(" ")
end

p test(nil, nil, nil)              # => "87.044000 Kbit/s 129.050000 Kbit/s"
p test(23, nil, nil)               # => "87.044000 Kbit/s 129.050000 Kbit/s"
# p test(nil, "256k", "128k")        # => "174.980000 Kbit/s 129.050000 Kbit/s"
# p test(nil, "256k", "192k")        # => "174.980000 Kbit/s 192.312000 Kbit/s"
# >> [AnimationMp4Builder] cd /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210915-52373-1aqjjn6
# >> [AnimationMp4Builder] [video] 1. 動画準備
# >> [AnimationMp4Builder] [video] 生成に使うもの: ffmpeg
# >> [AnimationMp4Builder] [video] 最後に追加するフレーム数(end_pages): 5
# >> [AnimationMp4Builder] [video] 1手当たりの秒数(page_duration): 1.0
# >> [AnimationMp4Builder] [video] 2021-09-15 08:53:03 1/14   7.14 % T1 初期配置
# >> [AnimationMp4Builder] [video] [0] static layer
# >> [AnimationMp4Builder] [video] [0] canvas_layer_create for s_canvas_layer
# >> [AnimationMp4Builder] [video] [0] transparent_layer create for s_board_layer BEGIN
# >> [AnimationMp4Builder] [video] [0] transparent_layer create for s_board_layer END
# >> [AnimationMp4Builder] [video] [0] transparent_layer create for s_lattice_layer BEGIN
# >> [AnimationMp4Builder] [video] [0] transparent_layer create for s_lattice_layer END
# >> [AnimationMp4Builder] [video] [0] dynamic layer
# >> [AnimationMp4Builder] [video] [0] transparent_layer create for d_move_layer BEGIN
# >> [AnimationMp4Builder] [video] [0] transparent_layer create for d_move_layer END
# >> [AnimationMp4Builder] [video] [0] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationMp4Builder] [video] [0] transparent_layer create for d_piece_layer END
# >> [AnimationMp4Builder] [video] [0] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationMp4Builder] [video] [0] transparent_layer create for d_piece_count_layer END
# >> [AnimationMp4Builder] [video] [0] composite process
# >> [AnimationMp4Builder] [video] 2021-09-15 08:53:04 2/14  14.29 % T0 終了図 1
# >> [AnimationMp4Builder] [video] 2021-09-15 08:53:04 3/14  21.43 % T0 終了図 2
# >> [AnimationMp4Builder] [video] 2021-09-15 08:53:04 4/14  28.57 % T0 終了図 3
# >> [AnimationMp4Builder] [video] 2021-09-15 08:53:04 5/14  35.71 % T0 終了図 4
# >> [AnimationMp4Builder] [video] 2021-09-15 08:53:04 6/14  42.86 % T0 終了図 5
# >> [AnimationMp4Builder] [video] 合計フレーム数(page_count): 6
# >> [AnimationMp4Builder] [video] ソース画像生成数: 6
# >> [AnimationMp4Builder] [video] 2021-09-15 08:53:04 7/14  50.00 % T0 mp4 生成
# >> [AnimationMp4Builder] [video] [execute] ffmpeg -v warning -hide_banner -framerate 10000/10000.0 -i _input%04d.png -c:v libx264 -pix_fmt yuv420p -movflags +faststart  -tune stillimage   -y _output1.mp4
# >> [AnimationMp4Builder] [video] [execute] elapsed: 1s
# >> [AnimationMp4Builder] [video] -rw-r--r-- 1 ikeda staff 65K  9 15 08:53 _output1.mp4
# >> [AnimationMp4Builder] [video] [clear_all] @s_canvas_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @s_board_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @s_lattice_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @d_move_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @d_piece_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @d_piece_count_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @last_rendered_image.destroy!
# >> [AnimationMp4Builder] 2021-09-15 08:53:05 8/14  57.14 % T1 メタデータ埋め込み
# >> [AnimationMp4Builder] [execute] ffmpeg -v warning -hide_banner -i _output1.mp4 -metadata title="0\手\目\ま\で\の\棋\譜" -metadata comment="position\ startpos" -codec copy -y _output2.mp4
# >> [AnimationMp4Builder] [execute] elapsed: 1s
# >> [AnimationMp4Builder] [audio] 2. BGM準備
# >> [AnimationMp4Builder] [audio] 予測した全体の秒数(total_duration): 6.0
# >> [AnimationMp4Builder] [audio] 開戦前のみ
# >> [AnimationMp4Builder] [audio] audio_part_x: /Users/ikeda/src/bioshogi/lib/bioshogi/assets/audios/headspin_long.m4a
# >> [AnimationMp4Builder] [audio] 2021-09-15 08:53:06 9/14  64.29 % T0 フェイドアウトと音量調整
# >> [AnimationMp4Builder] [audio] [execute] ffmpeg -v warning -stream_loop -1 -i /Users/ikeda/src/bioshogi/lib/bioshogi/assets/audios/headspin_long.m4a -t 6.0 -af volume=0.7,afade=t=out:start_time=1.0:duration=5.0  -y _same_length1.m4a
# >> [AnimationMp4Builder] [audio] [execute] elapsed: 1s
# >> [AnimationMp4Builder] [audio] headspin_long.m4a: 28.049705
# >> [AnimationMp4Builder] [audio] fadeout_duration: 5.0
# >> [AnimationMp4Builder] 3. 結合
# >> [AnimationMp4Builder] 2021-09-15 08:53:07 10/14  71.43 % T1 BGM結合
# >> [AnimationMp4Builder] [execute] ffmpeg -v warning -i _output2.mp4 -i _same_length1.m4a -c copy -y _output3.mp4
# >> [AnimationMp4Builder] [execute] elapsed: 1s
# >> [AnimationMp4Builder] rm -fr /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210915-52373-1aqjjn6
# >> "87.044000 Kbit/s 129.050000 Kbit/s"
# >> [AnimationMp4Builder] cd /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210915-52373-tlfzfz
# >> [AnimationMp4Builder] [video] 1. 動画準備
# >> [AnimationMp4Builder] [video] 生成に使うもの: ffmpeg
# >> [AnimationMp4Builder] [video] 最後に追加するフレーム数(end_pages): 5
# >> [AnimationMp4Builder] [video] 1手当たりの秒数(page_duration): 1.0
# >> [AnimationMp4Builder] [video] 2021-09-15 08:53:09 1/14   7.14 % T1 初期配置
# >> [AnimationMp4Builder] [video] [0] static layer
# >> [AnimationMp4Builder] [video] [0] canvas_layer_create for s_canvas_layer
# >> [AnimationMp4Builder] [video] [0] transparent_layer create for s_board_layer BEGIN
# >> [AnimationMp4Builder] [video] [0] transparent_layer create for s_board_layer END
# >> [AnimationMp4Builder] [video] [0] transparent_layer create for s_lattice_layer BEGIN
# >> [AnimationMp4Builder] [video] [0] transparent_layer create for s_lattice_layer END
# >> [AnimationMp4Builder] [video] [0] dynamic layer
# >> [AnimationMp4Builder] [video] [0] transparent_layer create for d_move_layer BEGIN
# >> [AnimationMp4Builder] [video] [0] transparent_layer create for d_move_layer END
# >> [AnimationMp4Builder] [video] [0] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationMp4Builder] [video] [0] transparent_layer create for d_piece_layer END
# >> [AnimationMp4Builder] [video] [0] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationMp4Builder] [video] [0] transparent_layer create for d_piece_count_layer END
# >> [AnimationMp4Builder] [video] [0] composite process
# >> [AnimationMp4Builder] [video] 2021-09-15 08:53:10 2/14  14.29 % T0 終了図 1
# >> [AnimationMp4Builder] [video] 2021-09-15 08:53:10 3/14  21.43 % T0 終了図 2
# >> [AnimationMp4Builder] [video] 2021-09-15 08:53:10 4/14  28.57 % T0 終了図 3
# >> [AnimationMp4Builder] [video] 2021-09-15 08:53:10 5/14  35.71 % T0 終了図 4
# >> [AnimationMp4Builder] [video] 2021-09-15 08:53:10 6/14  42.86 % T0 終了図 5
# >> [AnimationMp4Builder] [video] 合計フレーム数(page_count): 6
# >> [AnimationMp4Builder] [video] ソース画像生成数: 6
# >> [AnimationMp4Builder] [video] 2021-09-15 08:53:10 7/14  50.00 % T0 mp4 生成
# >> [AnimationMp4Builder] [video] [execute] ffmpeg -v warning -hide_banner -framerate 10000/10000.0 -i _input%04d.png -c:v libx264 -pix_fmt yuv420p -movflags +faststart -crf 23 -tune stillimage   -y _output1.mp4
# >> [AnimationMp4Builder] [video] [execute] elapsed: 1s
# >> [AnimationMp4Builder] [video] -rw-r--r-- 1 ikeda staff 65K  9 15 08:53 _output1.mp4
# >> [AnimationMp4Builder] [video] [clear_all] @s_canvas_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @s_board_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @s_lattice_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @d_move_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @d_piece_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @d_piece_count_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @last_rendered_image.destroy!
# >> [AnimationMp4Builder] 2021-09-15 08:53:11 8/14  57.14 % T1 メタデータ埋め込み
# >> [AnimationMp4Builder] [execute] ffmpeg -v warning -hide_banner -i _output1.mp4 -metadata title="0\手\目\ま\で\の\棋\譜" -metadata comment="position\ startpos" -codec copy -y _output2.mp4
# >> [AnimationMp4Builder] [execute] elapsed: 1s
# >> [AnimationMp4Builder] [audio] 2. BGM準備
# >> [AnimationMp4Builder] [audio] 予測した全体の秒数(total_duration): 6.0
# >> [AnimationMp4Builder] [audio] 開戦前のみ
# >> [AnimationMp4Builder] [audio] audio_part_x: /Users/ikeda/src/bioshogi/lib/bioshogi/assets/audios/headspin_long.m4a
# >> [AnimationMp4Builder] [audio] 2021-09-15 08:53:12 9/14  64.29 % T0 フェイドアウトと音量調整
# >> [AnimationMp4Builder] [audio] [execute] ffmpeg -v warning -stream_loop -1 -i /Users/ikeda/src/bioshogi/lib/bioshogi/assets/audios/headspin_long.m4a -t 6.0 -af volume=0.7,afade=t=out:start_time=1.0:duration=5.0  -y _same_length1.m4a
# >> [AnimationMp4Builder] [audio] [execute] elapsed: 1s
# >> [AnimationMp4Builder] [audio] headspin_long.m4a: 28.049705
# >> [AnimationMp4Builder] [audio] fadeout_duration: 5.0
# >> [AnimationMp4Builder] 3. 結合
# >> [AnimationMp4Builder] 2021-09-15 08:53:13 10/14  71.43 % T1 BGM結合
# >> [AnimationMp4Builder] [execute] ffmpeg -v warning -i _output2.mp4 -i _same_length1.m4a -c copy -y _output3.mp4
# >> [AnimationMp4Builder] [execute] elapsed: 1s
# >> [AnimationMp4Builder] rm -fr /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210915-52373-tlfzfz
# >> "87.044000 Kbit/s 129.050000 Kbit/s"
