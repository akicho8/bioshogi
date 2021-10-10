require "../setup"
Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
info = Parser.parse("position startpos moves 7g7f 3c3d 8h2b+ 8c8d")
bin = info.to_animation_mp4(end_duration: 10, main_volume: 0.5)
Pathname("_output.mp4").write(bin)   # => 344997
Media.enough_volume("_output.mp4")   # => 20.9
m`open -a 'Google Chrome' _output.mp4`
# >> [AnimationMp4Builder] cd /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210919-62026-lzldt8
# >> [AnimationMp4Builder] [video] 1. 動画準備
# >> [AnimationMp4Builder] [video] 生成に使うもの: ffmpeg
# >> [AnimationMp4Builder] [video] 最後に追加するページ数(end_pages): 10
# >> [AnimationMp4Builder] [video] 1手当たりの秒数(page_duration): 1.0
# >> [AnimationMp4Builder] [video] 2021-09-19 20:22:40 1/23   4.35 % T1 初期配置
# >> [AnimationMp4Builder] [video] [初期配置][begin]
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
# >> [AnimationMp4Builder] [video] [初期配置][end][0s]
# >> [AnimationMp4Builder] [video] 2021-09-19 20:22:40 2/23   8.70 % T0 (0/4) 7g7f
# >> [AnimationMp4Builder] [video] @mediator.execute OK
# >> [AnimationMp4Builder] [video] [0/4][begin]
# >> [AnimationMp4Builder] [video] [1] static layer
# >> [AnimationMp4Builder] [video] [1] dynamic layer
# >> [AnimationMp4Builder] [video] [1] transparent_layer create for d_move_layer BEGIN
# >> [AnimationMp4Builder] [video] [1] transparent_layer create for d_move_layer END
# >> [AnimationMp4Builder] [video] [1] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationMp4Builder] [video] [1] transparent_layer create for d_piece_layer END
# >> [AnimationMp4Builder] [video] [1] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationMp4Builder] [video] [1] transparent_layer create for d_piece_count_layer END
# >> [AnimationMp4Builder] [video] [1] composite process
# >> [AnimationMp4Builder] [video] [0/4][end][0s]
# >> [AnimationMp4Builder] [video] @image_renderer.next_build.write OK
# >> [AnimationMp4Builder] [video] move: 0 / 4
# >> [AnimationMp4Builder] [video] 2021-09-19 20:22:41 3/23  13.04 % T0 (1/4) 3c3d
# >> [AnimationMp4Builder] [video] @mediator.execute OK
# >> [AnimationMp4Builder] [video] [1/4][begin]
# >> [AnimationMp4Builder] [video] [2] static layer
# >> [AnimationMp4Builder] [video] [2] dynamic layer
# >> [AnimationMp4Builder] [video] [2] transparent_layer create for d_move_layer BEGIN
# >> [AnimationMp4Builder] [video] [2] transparent_layer create for d_move_layer END
# >> [AnimationMp4Builder] [video] [2] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationMp4Builder] [video] [2] transparent_layer create for d_piece_layer END
# >> [AnimationMp4Builder] [video] [2] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationMp4Builder] [video] [2] transparent_layer create for d_piece_count_layer END
# >> [AnimationMp4Builder] [video] [2] composite process
# >> [AnimationMp4Builder] [video] [1/4][end][0s]
# >> [AnimationMp4Builder] [video] @image_renderer.next_build.write OK
# >> [AnimationMp4Builder] [video] 2021-09-19 20:22:41 4/23  17.39 % T1 (2/4) 8h2b+
# >> [AnimationMp4Builder] [video] @mediator.execute OK
# >> [AnimationMp4Builder] [video] [2/4][begin]
# >> [AnimationMp4Builder] [video] [3] static layer
# >> [AnimationMp4Builder] [video] [3] dynamic layer
# >> [AnimationMp4Builder] [video] [3] transparent_layer create for d_move_layer BEGIN
# >> [AnimationMp4Builder] [video] [3] transparent_layer create for d_move_layer END
# >> [AnimationMp4Builder] [video] [3] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationMp4Builder] [video] [3] transparent_layer create for d_piece_layer END
# >> [AnimationMp4Builder] [video] [3] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationMp4Builder] [video] [3] transparent_layer create for d_piece_count_layer END
# >> [AnimationMp4Builder] [video] [3] composite process
# >> [AnimationMp4Builder] [video] [2/4][end][0s]
# >> [AnimationMp4Builder] [video] @image_renderer.next_build.write OK
# >> [AnimationMp4Builder] [video] 2021-09-19 20:22:41 5/23  21.74 % T0 (3/4) 8c8d
# >> [AnimationMp4Builder] [video] @mediator.execute OK
# >> [AnimationMp4Builder] [video] [3/4][begin]
# >> [AnimationMp4Builder] [video] [4] static layer
# >> [AnimationMp4Builder] [video] [4] dynamic layer
# >> [AnimationMp4Builder] [video] [4] transparent_layer create for d_move_layer BEGIN
# >> [AnimationMp4Builder] [video] [4] transparent_layer create for d_move_layer END
# >> [AnimationMp4Builder] [video] [4] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationMp4Builder] [video] [4] transparent_layer create for d_piece_layer END
# >> [AnimationMp4Builder] [video] [4] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationMp4Builder] [video] [4] transparent_layer create for d_piece_count_layer END
# >> [AnimationMp4Builder] [video] [4] composite process
# >> [AnimationMp4Builder] [video] [3/4][end][0s]
# >> [AnimationMp4Builder] [video] @image_renderer.next_build.write OK
# >> [AnimationMp4Builder] [video] 2021-09-19 20:22:42 6/23  26.09 % T0 終了図 0/10
# >> [AnimationMp4Builder] [video] [終了図 0/10][begin]
# >> [AnimationMp4Builder] [video] [終了図 0/10][end][0s]
# >> [AnimationMp4Builder] [video] 2021-09-19 20:22:42 7/23  30.43 % T0 終了図 1/10
# >> [AnimationMp4Builder] [video] [終了図 1/10][begin]
# >> [AnimationMp4Builder] [video] [終了図 1/10][end][0s]
# >> [AnimationMp4Builder] [video] 2021-09-19 20:22:42 8/23  34.78 % T1 終了図 2/10
# >> [AnimationMp4Builder] [video] [終了図 2/10][begin]
# >> [AnimationMp4Builder] [video] [終了図 2/10][end][0s]
# >> [AnimationMp4Builder] [video] 2021-09-19 20:22:42 9/23  39.13 % T0 終了図 3/10
# >> [AnimationMp4Builder] [video] [終了図 3/10][begin]
# >> [AnimationMp4Builder] [video] [終了図 3/10][end][0s]
# >> [AnimationMp4Builder] [video] 2021-09-19 20:22:42 10/23  43.48 % T0 終了図 4/10
# >> [AnimationMp4Builder] [video] [終了図 4/10][begin]
# >> [AnimationMp4Builder] [video] [終了図 4/10][end][0s]
# >> [AnimationMp4Builder] [video] 2021-09-19 20:22:42 11/23  47.83 % T0 終了図 5/10
# >> [AnimationMp4Builder] [video] [終了図 5/10][begin]
# >> [AnimationMp4Builder] [video] [終了図 5/10][end][0s]
# >> [AnimationMp4Builder] [video] 2021-09-19 20:22:42 12/23  52.17 % T0 終了図 6/10
# >> [AnimationMp4Builder] [video] [終了図 6/10][begin]
# >> [AnimationMp4Builder] [video] [終了図 6/10][end][0s]
# >> [AnimationMp4Builder] [video] 2021-09-19 20:22:43 13/23  56.52 % T0 終了図 7/10
# >> [AnimationMp4Builder] [video] [終了図 7/10][begin]
# >> [AnimationMp4Builder] [video] [終了図 7/10][end][0s]
# >> [AnimationMp4Builder] [video] 2021-09-19 20:22:43 14/23  60.87 % T0 終了図 8/10
# >> [AnimationMp4Builder] [video] [終了図 8/10][begin]
# >> [AnimationMp4Builder] [video] [終了図 8/10][end][0s]
# >> [AnimationMp4Builder] [video] 2021-09-19 20:22:43 15/23  65.22 % T1 終了図 9/10
# >> [AnimationMp4Builder] [video] [終了図 9/10][begin]
# >> [AnimationMp4Builder] [video] [終了図 9/10][end][0s]
# >> [AnimationMp4Builder] [video] ページ数: 15, 存在ファイル数: 15, ファイル名: _input%04d.png
# >> [AnimationMp4Builder] [video] ソース画像確認
# >> -rw-r--r-- 1 ikeda staff 34K  9 19 20:22 _input0000.png
# >> -rw-r--r-- 1 ikeda staff 35K  9 19 20:22 _input0001.png
# >> -rw-r--r-- 1 ikeda staff 36K  9 19 20:22 _input0002.png
# >> -rw-r--r-- 1 ikeda staff 72K  9 19 20:22 _input0003.png
# >> -rw-r--r-- 1 ikeda staff 74K  9 19 20:22 _input0004.png
# >> -rw-r--r-- 1 ikeda staff 74K  9 19 20:22 _input0005.png
# >> -rw-r--r-- 1 ikeda staff 74K  9 19 20:22 _input0006.png
# >> -rw-r--r-- 1 ikeda staff 74K  9 19 20:22 _input0007.png
# >> -rw-r--r-- 1 ikeda staff 74K  9 19 20:22 _input0008.png
# >> -rw-r--r-- 1 ikeda staff 74K  9 19 20:22 _input0009.png
# >> -rw-r--r-- 1 ikeda staff 74K  9 19 20:22 _input0010.png
# >> -rw-r--r-- 1 ikeda staff 74K  9 19 20:22 _input0011.png
# >> -rw-r--r-- 1 ikeda staff 74K  9 19 20:22 _input0012.png
# >> -rw-r--r-- 1 ikeda staff 74K  9 19 20:22 _input0013.png
# >> -rw-r--r-- 1 ikeda staff 74K  9 19 20:22 _input0014.png
# >> 
# >> [AnimationMp4Builder] [video] 2021-09-19 20:22:43 16/23  69.57 % T0 mp4 生成 15p
# >> [AnimationMp4Builder] [video] [execute] ffmpeg -v warning -hide_banner -framerate 10000/10000.0 -i _input%04d.png -c:v libx264 -pix_fmt yuv420p -movflags +faststart -crf 23 -tune stillimage   -y _output1.mp4
# >> [AnimationMp4Builder] [video] [execute] elapsed: 1s
# >> [AnimationMp4Builder] [video] -rw-r--r-- 1 ikeda staff 98K  9 19 20:22 _output1.mp4
# >> [AnimationMp4Builder] [video] [clear_all] @s_canvas_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @s_board_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @s_lattice_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @d_move_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @d_piece_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @d_piece_count_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @last_rendered_image.destroy!
# >> [AnimationMp4Builder] 2021-09-19 20:22:45 17/23  73.91 % T1 メタデータ埋め込み
# >> [AnimationMp4Builder] [execute] ffmpeg -v warning -hide_banner -i _output1.mp4 -metadata title="総手数4手" -metadata comment="position startpos moves 7g7f 3c3d 8h2b+ 8c8d" -codec copy -y _output2.mp4
# >> [AnimationMp4Builder] [execute] elapsed: 1s
# >> [AnimationMp4Builder] [audio] 2. BGM準備
# >> [AnimationMp4Builder] [audio] 予測した全体の秒数(total_duration): 15.0
# >> [AnimationMp4Builder] [audio] 開戦前のみ
# >> [AnimationMp4Builder] [audio] audio_part_x: /Users/ikeda/src/bioshogi/lib/bioshogi/assets/audios/headspin_long.m4a
# >> [AnimationMp4Builder] [audio] 2021-09-19 20:22:46 18/23  78.26 % T1 フェイドアウトと音量調整
# >> [AnimationMp4Builder] [audio] [execute] ffmpeg -v warning -stream_loop -1 -i /Users/ikeda/src/bioshogi/lib/bioshogi/assets/audios/headspin_long.m4a -t 15.0 -af volume=1.0,afade=t=out:start_time=5.0:duration=10.0  -y _same_length1.m4a
# >> [AnimationMp4Builder] [audio] [execute] elapsed: 1s
# >> [AnimationMp4Builder] [audio] headspin_long.m4a: 28.049705
# >> [AnimationMp4Builder] [audio] fadeout_duration: 10.0
# >> [AnimationMp4Builder] [audio] 2021-09-19 20:22:47 19/23  82.61 % T1 全体の音量調整
# >> [AnimationMp4Builder] [audio] [execute] ffmpeg -v warning -i _same_length1.m4a -af volume=0.1 -y _same_length2.m4a
# >> [AnimationMp4Builder] [audio] [execute] elapsed: 1s
# >> [AnimationMp4Builder] [audio] _same_length2.m4a: 15.001
# >> [AnimationMp4Builder] 3. 結合
# >> [AnimationMp4Builder] 2021-09-19 20:22:48 20/23  86.96 % T1 BGM結合
# >> [AnimationMp4Builder] [execute] ffmpeg -v warning -i _output2.mp4 -i _same_length2.m4a -c copy -y _output3.mp4
# >> [AnimationMp4Builder] [execute] elapsed: 1s
# >> [AnimationMp4Builder] rm -fr /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210919-62026-lzldt8
