require "../example_helper"
Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
info = Parser.parse("position startpos moves 7g7f 8c8d")

bin = info.to_animation_gif(page_duration: 0.5, factory_method_key: "rmagick", tmpdir_remove: false, color_theme_key: "is_color_theme_real_wood1")
Pathname("_output_rmagick.gif").write(bin) # => 161024
puts `identify _output_rmagick.gif`

bin = info.to_animation_gif(page_duration: 0.5, factory_method_key: "ffmpeg", tmpdir_remove: false, color_theme_key: "is_color_theme_real_wood1")
Pathname("_output.gif").write(bin) # => 925527
puts `identify _output.gif`

`open -a 'Google Chrome' _output.gif`

# >> [AnimationGifBuilder] cd /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20211003-72246-qlrs2g
# >> [AnimationGifBuilder] 生成に使うもの: rmagick
# >> [AnimationGifBuilder] 最後に追加するフレーム数(end_pages): 0
# >> [AnimationGifBuilder] 1手当たりの秒数(page_duration): 0.5
# >> [AnimationGifBuilder] 2021-10-03 15:31:15 1/7  14.29 % T1 初期配置
# >> [AnimationGifBuilder] [初期配置][begin]
# >> [AnimationGifBuilder] [0] static layer
# >> [AnimationGifBuilder] [0] canvas_layer_create for s_canvas_layer
# >> [AnimationGifBuilder] [0] transparent_layer create for s_board_layer BEGIN
# >> [AnimationGifBuilder] [0] transparent_layer create for s_board_layer END
# >> [AnimationGifBuilder] [0] transparent_layer create for s_lattice_layer BEGIN
# >> [AnimationGifBuilder] [0] transparent_layer create for s_lattice_layer END
# >> [AnimationGifBuilder] [0] dynamic layer
# >> [AnimationGifBuilder] [0] transparent_layer create for d_move_layer BEGIN
# >> [AnimationGifBuilder] [0] transparent_layer create for d_move_layer END
# >> [AnimationGifBuilder] [0] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationGifBuilder] [0] transparent_layer create for d_piece_layer END
# >> [AnimationGifBuilder] [0] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationGifBuilder] [0] transparent_layer create for d_piece_count_layer END
# >> [AnimationGifBuilder] [0] composite process
# >> [AnimationGifBuilder] [初期配置][end][1s]
# >> [AnimationGifBuilder] 2021-10-03 15:31:15 2/7  28.57 % T0 (0/2) 7g7f
# >> [AnimationGifBuilder] [0/2][begin]
# >> [AnimationGifBuilder] [1] static layer
# >> [AnimationGifBuilder] [1] dynamic layer
# >> [AnimationGifBuilder] [1] transparent_layer create for d_move_layer BEGIN
# >> [AnimationGifBuilder] [1] transparent_layer create for d_move_layer END
# >> [AnimationGifBuilder] [1] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationGifBuilder] [1] transparent_layer create for d_piece_layer END
# >> [AnimationGifBuilder] [1] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationGifBuilder] [1] transparent_layer create for d_piece_count_layer END
# >> [AnimationGifBuilder] [1] composite process
# >> [AnimationGifBuilder] [0/2][end][0s]
# >> [AnimationGifBuilder] move: 0 / 2
# >> [AnimationGifBuilder] 2021-10-03 15:31:16 3/7  42.86 % T1 (1/2) 8c8d
# >> [AnimationGifBuilder] [1/2][begin]
# >> [AnimationGifBuilder] [2] static layer
# >> [AnimationGifBuilder] [2] dynamic layer
# >> [AnimationGifBuilder] [2] transparent_layer create for d_move_layer BEGIN
# >> [AnimationGifBuilder] [2] transparent_layer create for d_move_layer END
# >> [AnimationGifBuilder] [2] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationGifBuilder] [2] transparent_layer create for d_piece_layer END
# >> [AnimationGifBuilder] [2] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationGifBuilder] [2] transparent_layer create for d_piece_count_layer END
# >> [AnimationGifBuilder] [2] composite process
# >> [AnimationGifBuilder] [1/2][end][1s]
# >> [AnimationGifBuilder] ticks_per_second: 100
# >> [AnimationGifBuilder] delay: 50
# >> [AnimationGifBuilder] 2021-10-03 15:31:16 4/7  57.14 % T0 最適化
# >> [AnimationGifBuilder] [optimize_layers][begin]
# >> [AnimationGifBuilder] [optimize_layers][end][1s]
# >> [AnimationGifBuilder] 2021-10-03 15:31:17 5/7  71.43 % T1 gif 生成
# >> [AnimationGifBuilder] [write][begin]
# >> [AnimationGifBuilder] [write][end][0s]
# >> [AnimationGifBuilder] [clear_all] @s_canvas_layer.destroy!
# >> [AnimationGifBuilder] [clear_all] @s_board_layer.destroy!
# >> [AnimationGifBuilder] [clear_all] @s_lattice_layer.destroy!
# >> [AnimationGifBuilder] [clear_all] @d_move_layer.destroy!
# >> [AnimationGifBuilder] [clear_all] @d_piece_layer.destroy!
# >> [AnimationGifBuilder] [clear_all] @d_piece_count_layer.destroy!
# >> [AnimationGifBuilder] [clear_all] @last_rendered_image.destroy!
# >> _output_rmagick.gif[0] GIF 1200x630 1200x630+0+0 8-bit sRGB 256c 0.000u 0:00.000
# >> _output_rmagick.gif[1] GIF 63x135 1200x630+447+348 8-bit sRGB 256c 0.000u 0:00.000
# >> _output_rmagick.gif[2] GIF 122x334 1200x630+387+148 8-bit sRGB 256c 161024B 0.000u 0:00.000
# >> [AnimationGifBuilder] cd /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20211003-72246-7ah82l
# >> [AnimationGifBuilder] 生成に使うもの: ffmpeg
# >> [AnimationGifBuilder] 最後に追加するフレーム数(end_pages): 0
# >> [AnimationGifBuilder] 1手当たりの秒数(page_duration): 0.5
# >> [AnimationGifBuilder] 2021-10-03 15:31:19 1/5  20.00 % T1 初期配置
# >> [AnimationGifBuilder] [初期配置][begin]
# >> [AnimationGifBuilder] [0] static layer
# >> [AnimationGifBuilder] [0] canvas_layer_create for s_canvas_layer
# >> [AnimationGifBuilder] [0] transparent_layer create for s_board_layer BEGIN
# >> [AnimationGifBuilder] [0] transparent_layer create for s_board_layer END
# >> [AnimationGifBuilder] [0] transparent_layer create for s_lattice_layer BEGIN
# >> [AnimationGifBuilder] [0] transparent_layer create for s_lattice_layer END
# >> [AnimationGifBuilder] [0] dynamic layer
# >> [AnimationGifBuilder] [0] transparent_layer create for d_move_layer BEGIN
# >> [AnimationGifBuilder] [0] transparent_layer create for d_move_layer END
# >> [AnimationGifBuilder] [0] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationGifBuilder] [0] transparent_layer create for d_piece_layer END
# >> [AnimationGifBuilder] [0] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationGifBuilder] [0] transparent_layer create for d_piece_count_layer END
# >> [AnimationGifBuilder] [0] composite process
# >> [AnimationGifBuilder] [初期配置][end][1s]
# >> [AnimationGifBuilder] 2021-10-03 15:31:20 2/5  40.00 % T1 (0/2) 7g7f
# >> [AnimationGifBuilder] [0/2][begin]
# >> [AnimationGifBuilder] [1] static layer
# >> [AnimationGifBuilder] [1] dynamic layer
# >> [AnimationGifBuilder] [1] transparent_layer create for d_move_layer BEGIN
# >> [AnimationGifBuilder] [1] transparent_layer create for d_move_layer END
# >> [AnimationGifBuilder] [1] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationGifBuilder] [1] transparent_layer create for d_piece_layer END
# >> [AnimationGifBuilder] [1] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationGifBuilder] [1] transparent_layer create for d_piece_count_layer END
# >> [AnimationGifBuilder] [1] composite process
# >> [AnimationGifBuilder] [0/2][end][1s]
# >> [AnimationGifBuilder] move: 0 / 2
# >> [AnimationGifBuilder] 2021-10-03 15:31:21 3/5  60.00 % T0 (1/2) 8c8d
# >> [AnimationGifBuilder] [1/2][begin]
# >> [AnimationGifBuilder] [2] static layer
# >> [AnimationGifBuilder] [2] dynamic layer
# >> [AnimationGifBuilder] [2] transparent_layer create for d_move_layer BEGIN
# >> [AnimationGifBuilder] [2] transparent_layer create for d_move_layer END
# >> [AnimationGifBuilder] [2] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationGifBuilder] [2] transparent_layer create for d_piece_layer END
# >> [AnimationGifBuilder] [2] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationGifBuilder] [2] transparent_layer create for d_piece_count_layer END
# >> [AnimationGifBuilder] [2] composite process
# >> [AnimationGifBuilder] [1/2][end][1s]
# >> [AnimationGifBuilder] 2021-10-03 15:31:22 4/5  80.00 % T1 gif 生成 3p
# >> [AnimationGifBuilder] ページ数: 3, 存在ファイル数: 3, ファイル名: _input%04d.png
# >> [AnimationGifBuilder] ソース画像確認
# >> -rw-r--r-- 1 ikeda staff 396K 10  3 15:31 _input0000.png
# >> -rw-r--r-- 1 ikeda staff 400K 10  3 15:31 _input0001.png
# >> -rw-r--r-- 1 ikeda staff 404K 10  3 15:31 _input0002.png
# >> 
# >> [AnimationGifBuilder] [execute] ffmpeg -v warning -hide_banner -framerate 10000/5000.0 -i _input%04d.png  -y _output1.gif
# >> [AnimationGifBuilder] [execute] elapsed: 1s
# >> [AnimationGifBuilder] -rw-r--r-- 1 ikeda staff 904K 10  3 15:31 _output1.gif
# >> [AnimationGifBuilder] [clear_all] @s_canvas_layer.destroy!
# >> [AnimationGifBuilder] [clear_all] @s_board_layer.destroy!
# >> [AnimationGifBuilder] [clear_all] @s_lattice_layer.destroy!
# >> [AnimationGifBuilder] [clear_all] @d_move_layer.destroy!
# >> [AnimationGifBuilder] [clear_all] @d_piece_layer.destroy!
# >> [AnimationGifBuilder] [clear_all] @d_piece_count_layer.destroy!
# >> [AnimationGifBuilder] [clear_all] @last_rendered_image.destroy!
# >> _output.gif[0] GIF 1200x630 1200x630+0+0 8-bit sRGB 256c 0.000u 0:00.001
# >> _output.gif[1] GIF 1200x630 1200x630+0+0 8-bit sRGB 256c 0.000u 0:00.001
# >> _output.gif[2] GIF 1200x630 1200x630+0+0 8-bit sRGB 256c 925527B 0.000u 0:00.000
