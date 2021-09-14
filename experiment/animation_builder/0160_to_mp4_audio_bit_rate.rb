require "../example_helper"
Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

def test(video_bit_rate, audio_bit_rate)
  info = Parser.parse("position startpos")
  bin = info.to_mp4({
      :one_frame_duration_sec => 1,
      :end_duration_sec       => 5,
      :audio_theme_key        => "audio_theme_is_headspin_only",
      :video_bit_rate         => video_bit_rate, # default は 200k とネットにはあるが実際は 68k ぐらいじゃない？
      :audio_bit_rate         => audio_bit_rate, # default: 128k
    })
  Pathname("_output.mp4").write(bin) # => 140992, 230730, 278176
  [
    Media.video_bit_rate("_output.mp4"),
    Media.audio_bit_rate("_output.mp4"),
  ].join(" ")
end

p test(nil, nil)              # => "55.328000 Kbit/s 129.050000 Kbit/s"
p test("256k", "128k")        # => "174.980000 Kbit/s 129.050000 Kbit/s"
p test("256k", "192k")        # => "174.980000 Kbit/s 192.312000 Kbit/s"
# >> [Mp4Builder] cd /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210914-13749-1h3xm4e
# >> [Mp4Builder] [video] 1. 動画準備
# >> [Mp4Builder] [video] 生成に使うもの: ffmpeg
# >> [Mp4Builder] [video] 最後に追加するフレーム数(end_frames): 5
# >> [Mp4Builder] [video] 1手当たりの秒数(one_frame_duration_sec): 1.0
# >> [Mp4Builder] [video] 2021-09-14 21:22:50 1/14   7.14 % T1 初期配置
# >> [Mp4Builder] [video] [0] static layer
# >> [Mp4Builder] [video] [0] canvas_layer_create for s_canvas_layer
# >> [Mp4Builder] [video] [0] transparent_layer create for s_board_layer BEGIN
# >> [Mp4Builder] [video] [0] transparent_layer create for s_board_layer END
# >> [Mp4Builder] [video] [0] transparent_layer create for s_lattice_layer BEGIN
# >> [Mp4Builder] [video] [0] transparent_layer create for s_lattice_layer END
# >> [Mp4Builder] [video] [0] dynamic layer
# >> [Mp4Builder] [video] [0] transparent_layer create for d_move_layer BEGIN
# >> [Mp4Builder] [video] [0] transparent_layer create for d_move_layer END
# >> [Mp4Builder] [video] [0] transparent_layer create for d_piece_layer BEGIN
# >> [Mp4Builder] [video] [0] transparent_layer create for d_piece_layer END
# >> [Mp4Builder] [video] [0] transparent_layer create for d_piece_count_layer BEGIN
# >> [Mp4Builder] [video] [0] transparent_layer create for d_piece_count_layer END
# >> [Mp4Builder] [video] [0] composite process
# >> [Mp4Builder] [video] 2021-09-14 21:22:50 2/14  14.29 % T0 終了図 1
# >> [Mp4Builder] [video] 2021-09-14 21:22:50 3/14  21.43 % T0 終了図 2
# >> [Mp4Builder] [video] 2021-09-14 21:22:50 4/14  28.57 % T0 終了図 3
# >> [Mp4Builder] [video] 2021-09-14 21:22:51 5/14  35.71 % T0 終了図 4
# >> [Mp4Builder] [video] 2021-09-14 21:22:51 6/14  42.86 % T0 終了図 5
# >> [Mp4Builder] [video] 合計フレーム数(frame_count): 6
# >> [Mp4Builder] [video] ソース画像生成数: 6
# >> [Mp4Builder] [video] 2021-09-14 21:22:51 7/14  50.00 % T0 mp4 生成
# >> [Mp4Builder] [video] [execute] ffmpeg -v warning -hide_banner -framerate 10000/10000.0 -i _input%04d.png -c:v libx264 -pix_fmt yuv420p -movflags +faststart   -y _output1.mp4
# >> [Mp4Builder] [video] [execute] elapsed: 1s
# >> [Mp4Builder] [video] -rw-r--r-- 1 ikeda staff 42K  9 14 21:22 _output1.mp4
# >> [Mp4Builder] [video] [clear_all] @s_canvas_layer.destroy!
# >> [Mp4Builder] [video] [clear_all] @s_board_layer.destroy!
# >> [Mp4Builder] [video] [clear_all] @s_lattice_layer.destroy!
# >> [Mp4Builder] [video] [clear_all] @d_move_layer.destroy!
# >> [Mp4Builder] [video] [clear_all] @d_piece_layer.destroy!
# >> [Mp4Builder] [video] [clear_all] @d_piece_count_layer.destroy!
# >> [Mp4Builder] [video] [clear_all] @last_rendered_image.destroy!
# >> [Mp4Builder] 2021-09-14 21:22:52 8/14  57.14 % T1 メタデータ埋め込み
# >> [Mp4Builder] [execute] ffmpeg -v warning -hide_banner -i _output1.mp4 -metadata title="0手目までの棋譜" -metadata comment="position startpos" -codec copy -y _output2.mp4
# >> [Mp4Builder] [execute] elapsed: 1s
# >> [Mp4Builder] [audio] 2. BGM準備
# >> [Mp4Builder] [audio] 予測した全体の秒数(total_duration): 6.0
# >> [Mp4Builder] [audio] 開戦前のみ
# >> [Mp4Builder] [audio] audio_part_x: /Users/ikeda/src/bioshogi/lib/bioshogi/assets/audios/headspin_long.m4a
# >> [Mp4Builder] [audio] 2021-09-14 21:22:53 9/14  64.29 % T1 フェイドアウトと音量調整
# >> [Mp4Builder] [audio] [execute] ffmpeg -v warning -stream_loop -1 -i /Users/ikeda/src/bioshogi/lib/bioshogi/assets/audios/headspin_long.m4a -t 6.0 -af volume=0.7,afade=t=out:start_time=1.0:duration=5.0  -y _same_length1.m4a
# >> [Mp4Builder] [audio] [execute] elapsed: 1s
# >> [Mp4Builder] [audio] headspin_long.m4a: 28.049705
# >> [Mp4Builder] [audio] fadeout_duration: 5.0
# >> [Mp4Builder] 3. 結合
# >> [Mp4Builder] 2021-09-14 21:22:54 10/14  71.43 % T1 BGM結合
# >> [Mp4Builder] [execute] ffmpeg -v warning -i _output2.mp4 -i _same_length1.m4a -c copy -y _output3.mp4
# >> [Mp4Builder] [execute] elapsed: 1s
# >> [Mp4Builder] rm -fr /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210914-13749-1h3xm4e
# >> "55.328000 Kbit/s 129.050000 Kbit/s"
# >> [Mp4Builder] cd /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210914-13749-th2132
# >> [Mp4Builder] [video] 1. 動画準備
# >> [Mp4Builder] [video] 生成に使うもの: ffmpeg
# >> [Mp4Builder] [video] 最後に追加するフレーム数(end_frames): 5
# >> [Mp4Builder] [video] 1手当たりの秒数(one_frame_duration_sec): 1.0
# >> [Mp4Builder] [video] 2021-09-14 21:22:56 1/14   7.14 % T1 初期配置
# >> [Mp4Builder] [video] [0] static layer
# >> [Mp4Builder] [video] [0] canvas_layer_create for s_canvas_layer
# >> [Mp4Builder] [video] [0] transparent_layer create for s_board_layer BEGIN
# >> [Mp4Builder] [video] [0] transparent_layer create for s_board_layer END
# >> [Mp4Builder] [video] [0] transparent_layer create for s_lattice_layer BEGIN
# >> [Mp4Builder] [video] [0] transparent_layer create for s_lattice_layer END
# >> [Mp4Builder] [video] [0] dynamic layer
# >> [Mp4Builder] [video] [0] transparent_layer create for d_move_layer BEGIN
# >> [Mp4Builder] [video] [0] transparent_layer create for d_move_layer END
# >> [Mp4Builder] [video] [0] transparent_layer create for d_piece_layer BEGIN
# >> [Mp4Builder] [video] [0] transparent_layer create for d_piece_layer END
# >> [Mp4Builder] [video] [0] transparent_layer create for d_piece_count_layer BEGIN
# >> [Mp4Builder] [video] [0] transparent_layer create for d_piece_count_layer END
# >> [Mp4Builder] [video] [0] composite process
# >> [Mp4Builder] [video] 2021-09-14 21:22:56 2/14  14.29 % T0 終了図 1
# >> [Mp4Builder] [video] 2021-09-14 21:22:56 3/14  21.43 % T0 終了図 2
# >> [Mp4Builder] [video] 2021-09-14 21:22:56 4/14  28.57 % T0 終了図 3
# >> [Mp4Builder] [video] 2021-09-14 21:22:57 5/14  35.71 % T0 終了図 4
# >> [Mp4Builder] [video] 2021-09-14 21:22:57 6/14  42.86 % T0 終了図 5
# >> [Mp4Builder] [video] 合計フレーム数(frame_count): 6
# >> [Mp4Builder] [video] ソース画像生成数: 6
# >> [Mp4Builder] [video] 2021-09-14 21:22:57 7/14  50.00 % T0 mp4 生成
# >> [Mp4Builder] [video] [execute] ffmpeg -v warning -hide_banner -framerate 10000/10000.0 -i _input%04d.png -c:v libx264 -pix_fmt yuv420p -movflags +faststart -b:v 256k  -y _output1.mp4
# >> [Mp4Builder] [video] [execute] elapsed: 1s
# >> [Mp4Builder] [video] -rw-r--r-- 1 ikeda staff 130K  9 14 21:22 _output1.mp4
# >> [Mp4Builder] [video] [clear_all] @s_canvas_layer.destroy!
# >> [Mp4Builder] [video] [clear_all] @s_board_layer.destroy!
# >> [Mp4Builder] [video] [clear_all] @s_lattice_layer.destroy!
# >> [Mp4Builder] [video] [clear_all] @d_move_layer.destroy!
# >> [Mp4Builder] [video] [clear_all] @d_piece_layer.destroy!
# >> [Mp4Builder] [video] [clear_all] @d_piece_count_layer.destroy!
# >> [Mp4Builder] [video] [clear_all] @last_rendered_image.destroy!
# >> [Mp4Builder] 2021-09-14 21:22:58 8/14  57.14 % T1 メタデータ埋め込み
# >> [Mp4Builder] [execute] ffmpeg -v warning -hide_banner -i _output1.mp4 -metadata title="0手目までの棋譜" -metadata comment="position startpos" -codec copy -y _output2.mp4
# >> [Mp4Builder] [execute] elapsed: 1s
# >> [Mp4Builder] [audio] 2. BGM準備
# >> [Mp4Builder] [audio] 予測した全体の秒数(total_duration): 6.0
# >> [Mp4Builder] [audio] 開戦前のみ
# >> [Mp4Builder] [audio] audio_part_x: /Users/ikeda/src/bioshogi/lib/bioshogi/assets/audios/headspin_long.m4a
# >> [Mp4Builder] [audio] 2021-09-14 21:22:59 9/14  64.29 % T0 フェイドアウトと音量調整
# >> [Mp4Builder] [audio] [execute] ffmpeg -v warning -stream_loop -1 -i /Users/ikeda/src/bioshogi/lib/bioshogi/assets/audios/headspin_long.m4a -t 6.0 -af volume=0.7,afade=t=out:start_time=1.0:duration=5.0 -b:a 128k -y _same_length1.m4a
# >> [Mp4Builder] [audio] [execute] elapsed: 1s
# >> [Mp4Builder] [audio] headspin_long.m4a: 28.049705
# >> [Mp4Builder] [audio] fadeout_duration: 5.0
# >> [Mp4Builder] 3. 結合
# >> [Mp4Builder] 2021-09-14 21:23:00 10/14  71.43 % T1 BGM結合
# >> [Mp4Builder] [execute] ffmpeg -v warning -i _output2.mp4 -i _same_length1.m4a -c copy -y _output3.mp4
# >> [Mp4Builder] [execute] elapsed: 1s
# >> [Mp4Builder] rm -fr /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210914-13749-th2132
# >> "174.980000 Kbit/s 129.050000 Kbit/s"
# >> [Mp4Builder] cd /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210914-13749-g7pmez
# >> [Mp4Builder] [video] 1. 動画準備
# >> [Mp4Builder] [video] 生成に使うもの: ffmpeg
# >> [Mp4Builder] [video] 最後に追加するフレーム数(end_frames): 5
# >> [Mp4Builder] [video] 1手当たりの秒数(one_frame_duration_sec): 1.0
# >> [Mp4Builder] [video] 2021-09-14 21:23:02 1/14   7.14 % T1 初期配置
# >> [Mp4Builder] [video] [0] static layer
# >> [Mp4Builder] [video] [0] canvas_layer_create for s_canvas_layer
# >> [Mp4Builder] [video] [0] transparent_layer create for s_board_layer BEGIN
# >> [Mp4Builder] [video] [0] transparent_layer create for s_board_layer END
# >> [Mp4Builder] [video] [0] transparent_layer create for s_lattice_layer BEGIN
# >> [Mp4Builder] [video] [0] transparent_layer create for s_lattice_layer END
# >> [Mp4Builder] [video] [0] dynamic layer
# >> [Mp4Builder] [video] [0] transparent_layer create for d_move_layer BEGIN
# >> [Mp4Builder] [video] [0] transparent_layer create for d_move_layer END
# >> [Mp4Builder] [video] [0] transparent_layer create for d_piece_layer BEGIN
# >> [Mp4Builder] [video] [0] transparent_layer create for d_piece_layer END
# >> [Mp4Builder] [video] [0] transparent_layer create for d_piece_count_layer BEGIN
# >> [Mp4Builder] [video] [0] transparent_layer create for d_piece_count_layer END
# >> [Mp4Builder] [video] [0] composite process
# >> [Mp4Builder] [video] 2021-09-14 21:23:02 2/14  14.29 % T0 終了図 1
# >> [Mp4Builder] [video] 2021-09-14 21:23:02 3/14  21.43 % T0 終了図 2
# >> [Mp4Builder] [video] 2021-09-14 21:23:02 4/14  28.57 % T0 終了図 3
# >> [Mp4Builder] [video] 2021-09-14 21:23:02 5/14  35.71 % T0 終了図 4
# >> [Mp4Builder] [video] 2021-09-14 21:23:02 6/14  42.86 % T0 終了図 5
# >> [Mp4Builder] [video] 合計フレーム数(frame_count): 6
# >> [Mp4Builder] [video] ソース画像生成数: 6
# >> [Mp4Builder] [video] 2021-09-14 21:23:02 7/14  50.00 % T0 mp4 生成
# >> [Mp4Builder] [video] [execute] ffmpeg -v warning -hide_banner -framerate 10000/10000.0 -i _input%04d.png -c:v libx264 -pix_fmt yuv420p -movflags +faststart -b:v 256k  -y _output1.mp4
# >> [Mp4Builder] [video] [execute] elapsed: 1s
# >> [Mp4Builder] [video] -rw-r--r-- 1 ikeda staff 130K  9 14 21:23 _output1.mp4
# >> [Mp4Builder] [video] [clear_all] @s_canvas_layer.destroy!
# >> [Mp4Builder] [video] [clear_all] @s_board_layer.destroy!
# >> [Mp4Builder] [video] [clear_all] @s_lattice_layer.destroy!
# >> [Mp4Builder] [video] [clear_all] @d_move_layer.destroy!
# >> [Mp4Builder] [video] [clear_all] @d_piece_layer.destroy!
# >> [Mp4Builder] [video] [clear_all] @d_piece_count_layer.destroy!
# >> [Mp4Builder] [video] [clear_all] @last_rendered_image.destroy!
# >> [Mp4Builder] 2021-09-14 21:23:03 8/14  57.14 % T1 メタデータ埋め込み
# >> [Mp4Builder] [execute] ffmpeg -v warning -hide_banner -i _output1.mp4 -metadata title="0手目までの棋譜" -metadata comment="position startpos" -codec copy -y _output2.mp4
# >> [Mp4Builder] [execute] elapsed: 1s
# >> [Mp4Builder] [audio] 2. BGM準備
# >> [Mp4Builder] [audio] 予測した全体の秒数(total_duration): 6.0
# >> [Mp4Builder] [audio] 開戦前のみ
# >> [Mp4Builder] [audio] audio_part_x: /Users/ikeda/src/bioshogi/lib/bioshogi/assets/audios/headspin_long.m4a
# >> [Mp4Builder] [audio] 2021-09-14 21:23:04 9/14  64.29 % T0 フェイドアウトと音量調整
# >> [Mp4Builder] [audio] [execute] ffmpeg -v warning -stream_loop -1 -i /Users/ikeda/src/bioshogi/lib/bioshogi/assets/audios/headspin_long.m4a -t 6.0 -af volume=0.7,afade=t=out:start_time=1.0:duration=5.0 -b:a 192k -y _same_length1.m4a
# >> [Mp4Builder] [audio] [execute] elapsed: 1s
# >> [Mp4Builder] [audio] headspin_long.m4a: 28.049705
# >> [Mp4Builder] [audio] fadeout_duration: 5.0
# >> [Mp4Builder] 3. 結合
# >> [Mp4Builder] 2021-09-14 21:23:06 10/14  71.43 % T1 BGM結合
# >> [Mp4Builder] [execute] ffmpeg -v warning -i _output2.mp4 -i _same_length1.m4a -c copy -y _output3.mp4
# >> [Mp4Builder] [execute] elapsed: 1s
# >> [Mp4Builder] rm -fr /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210914-13749-g7pmez
# >> "174.980000 Kbit/s 192.312000 Kbit/s"
