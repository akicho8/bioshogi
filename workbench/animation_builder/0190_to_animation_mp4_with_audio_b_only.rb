require "../setup"
Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
sfen = "position startpos moves 7g7f 3c3d 8h2b+ 8c8d"
info = Parser.parse(sfen)
bin = info.to_animation_mp4({
    page_duration: 1.0,
    tmpdir_remove: false,
    end_duration: 0,
    audio_theme_key: nil,
    audio_part_a: nil,
    })
Pathname("_output.mp4").write(bin) # => 89679
Media.duration("_output.mp4")      # => 13.0
Media.p("_output.mp4")
tp Media.format("_output.mp4")
`open -a 'Google Chrome' _output.mp4`
# >> [AnimationMp4Builder] cd /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20210907-59099-jhjwec
# >> [AnimationMp4Builder] [video] 1. 動画準備
# >> [AnimationMp4Builder] [video] 生成に使うもの: ffmpeg
# >> [AnimationMp4Builder] [video] 最後に追加するフレーム数(end_pages): 0
# >> [AnimationMp4Builder] [video] 1手当たりの秒数(page_duration): 1.0
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
# >> [AnimationMp4Builder] [video] @container.execute OK
# >> [AnimationMp4Builder] [video] [1] static layer
# >> [AnimationMp4Builder] [video] [1] dynamic layer
# >> [AnimationMp4Builder] [video] [1] transparent_layer create for d_move_layer BEGIN
# >> [AnimationMp4Builder] [video] [1] transparent_layer create for d_move_layer END
# >> [AnimationMp4Builder] [video] [1] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationMp4Builder] [video] [1] transparent_layer create for d_piece_layer END
# >> [AnimationMp4Builder] [video] [1] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationMp4Builder] [video] [1] transparent_layer create for d_piece_count_layer END
# >> [AnimationMp4Builder] [video] [1] composite process
# >> [AnimationMp4Builder] [video] @screen_image_renderer.next_build.write OK
# >> [AnimationMp4Builder] [video] move: 0 / 12
# >> [AnimationMp4Builder] [video] @container.execute OK
# >> [AnimationMp4Builder] [video] [2] static layer
# >> [AnimationMp4Builder] [video] [2] dynamic layer
# >> [AnimationMp4Builder] [video] [2] transparent_layer create for d_move_layer BEGIN
# >> [AnimationMp4Builder] [video] [2] transparent_layer create for d_move_layer END
# >> [AnimationMp4Builder] [video] [2] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationMp4Builder] [video] [2] transparent_layer create for d_piece_layer END
# >> [AnimationMp4Builder] [video] [2] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationMp4Builder] [video] [2] transparent_layer create for d_piece_count_layer END
# >> [AnimationMp4Builder] [video] [2] composite process
# >> [AnimationMp4Builder] [video] @screen_image_renderer.next_build.write OK
# >> [AnimationMp4Builder] [video] @container.execute OK
# >> [AnimationMp4Builder] [video] [3] static layer
# >> [AnimationMp4Builder] [video] [3] dynamic layer
# >> [AnimationMp4Builder] [video] [3] transparent_layer create for d_move_layer BEGIN
# >> [AnimationMp4Builder] [video] [3] transparent_layer create for d_move_layer END
# >> [AnimationMp4Builder] [video] [3] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationMp4Builder] [video] [3] transparent_layer create for d_piece_layer END
# >> [AnimationMp4Builder] [video] [3] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationMp4Builder] [video] [3] transparent_layer create for d_piece_count_layer END
# >> [AnimationMp4Builder] [video] [3] composite process
# >> [AnimationMp4Builder] [video] @screen_image_renderer.next_build.write OK
# >> [AnimationMp4Builder] [video] @container.execute OK
# >> [AnimationMp4Builder] [video] [4] static layer
# >> [AnimationMp4Builder] [video] [4] dynamic layer
# >> [AnimationMp4Builder] [video] [4] transparent_layer create for d_move_layer BEGIN
# >> [AnimationMp4Builder] [video] [4] transparent_layer create for d_move_layer END
# >> [AnimationMp4Builder] [video] [4] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationMp4Builder] [video] [4] transparent_layer create for d_piece_layer END
# >> [AnimationMp4Builder] [video] [4] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationMp4Builder] [video] [4] transparent_layer create for d_piece_count_layer END
# >> [AnimationMp4Builder] [video] [4] composite process
# >> [AnimationMp4Builder] [video] @screen_image_renderer.next_build.write OK
# >> [AnimationMp4Builder] [video] @container.execute OK
# >> [AnimationMp4Builder] [video] [5] static layer
# >> [AnimationMp4Builder] [video] [5] dynamic layer
# >> [AnimationMp4Builder] [video] [5] transparent_layer create for d_move_layer BEGIN
# >> [AnimationMp4Builder] [video] [5] transparent_layer create for d_move_layer END
# >> [AnimationMp4Builder] [video] [5] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationMp4Builder] [video] [5] transparent_layer create for d_piece_layer END
# >> [AnimationMp4Builder] [video] [5] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationMp4Builder] [video] [5] transparent_layer create for d_piece_count_layer END
# >> [AnimationMp4Builder] [video] [5] composite process
# >> [AnimationMp4Builder] [video] @screen_image_renderer.next_build.write OK
# >> [AnimationMp4Builder] [video] @container.execute OK
# >> [AnimationMp4Builder] [video] [6] static layer
# >> [AnimationMp4Builder] [video] [6] dynamic layer
# >> [AnimationMp4Builder] [video] [6] transparent_layer create for d_move_layer BEGIN
# >> [AnimationMp4Builder] [video] [6] transparent_layer create for d_move_layer END
# >> [AnimationMp4Builder] [video] [6] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationMp4Builder] [video] [6] transparent_layer create for d_piece_layer END
# >> [AnimationMp4Builder] [video] [6] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationMp4Builder] [video] [6] transparent_layer create for d_piece_count_layer END
# >> [AnimationMp4Builder] [video] [6] composite process
# >> [AnimationMp4Builder] [video] @screen_image_renderer.next_build.write OK
# >> [AnimationMp4Builder] [video] @container.execute OK
# >> [AnimationMp4Builder] [video] [7] static layer
# >> [AnimationMp4Builder] [video] [7] dynamic layer
# >> [AnimationMp4Builder] [video] [7] transparent_layer create for d_move_layer BEGIN
# >> [AnimationMp4Builder] [video] [7] transparent_layer create for d_move_layer END
# >> [AnimationMp4Builder] [video] [7] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationMp4Builder] [video] [7] transparent_layer create for d_piece_layer END
# >> [AnimationMp4Builder] [video] [7] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationMp4Builder] [video] [7] transparent_layer create for d_piece_count_layer END
# >> [AnimationMp4Builder] [video] [7] composite process
# >> [AnimationMp4Builder] [video] @screen_image_renderer.next_build.write OK
# >> [AnimationMp4Builder] [video] @container.execute OK
# >> [AnimationMp4Builder] [video] [8] static layer
# >> [AnimationMp4Builder] [video] [8] dynamic layer
# >> [AnimationMp4Builder] [video] [8] transparent_layer create for d_move_layer BEGIN
# >> [AnimationMp4Builder] [video] [8] transparent_layer create for d_move_layer END
# >> [AnimationMp4Builder] [video] [8] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationMp4Builder] [video] [8] transparent_layer create for d_piece_layer END
# >> [AnimationMp4Builder] [video] [8] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationMp4Builder] [video] [8] transparent_layer create for d_piece_count_layer END
# >> [AnimationMp4Builder] [video] [8] composite process
# >> [AnimationMp4Builder] [video] @screen_image_renderer.next_build.write OK
# >> [AnimationMp4Builder] [video] @container.execute OK
# >> [AnimationMp4Builder] [video] [9] static layer
# >> [AnimationMp4Builder] [video] [9] dynamic layer
# >> [AnimationMp4Builder] [video] [9] transparent_layer create for d_move_layer BEGIN
# >> [AnimationMp4Builder] [video] [9] transparent_layer create for d_move_layer END
# >> [AnimationMp4Builder] [video] [9] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationMp4Builder] [video] [9] transparent_layer create for d_piece_layer END
# >> [AnimationMp4Builder] [video] [9] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationMp4Builder] [video] [9] transparent_layer create for d_piece_count_layer END
# >> [AnimationMp4Builder] [video] [9] composite process
# >> [AnimationMp4Builder] [video] @screen_image_renderer.next_build.write OK
# >> [AnimationMp4Builder] [video] @container.execute OK
# >> [AnimationMp4Builder] [video] [10] static layer
# >> [AnimationMp4Builder] [video] [10] dynamic layer
# >> [AnimationMp4Builder] [video] [10] transparent_layer create for d_move_layer BEGIN
# >> [AnimationMp4Builder] [video] [10] transparent_layer create for d_move_layer END
# >> [AnimationMp4Builder] [video] [10] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationMp4Builder] [video] [10] transparent_layer create for d_piece_layer END
# >> [AnimationMp4Builder] [video] [10] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationMp4Builder] [video] [10] transparent_layer create for d_piece_count_layer END
# >> [AnimationMp4Builder] [video] [10] composite process
# >> [AnimationMp4Builder] [video] @screen_image_renderer.next_build.write OK
# >> [AnimationMp4Builder] [video] @container.execute OK
# >> [AnimationMp4Builder] [video] [11] static layer
# >> [AnimationMp4Builder] [video] [11] dynamic layer
# >> [AnimationMp4Builder] [video] [11] transparent_layer create for d_move_layer BEGIN
# >> [AnimationMp4Builder] [video] [11] transparent_layer create for d_move_layer END
# >> [AnimationMp4Builder] [video] [11] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationMp4Builder] [video] [11] transparent_layer create for d_piece_layer END
# >> [AnimationMp4Builder] [video] [11] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationMp4Builder] [video] [11] transparent_layer create for d_piece_count_layer END
# >> [AnimationMp4Builder] [video] [11] composite process
# >> [AnimationMp4Builder] [video] @screen_image_renderer.next_build.write OK
# >> [AnimationMp4Builder] [video] move: 10 / 12
# >> [AnimationMp4Builder] [video] @container.execute OK
# >> [AnimationMp4Builder] [video] [12] static layer
# >> [AnimationMp4Builder] [video] [12] dynamic layer
# >> [AnimationMp4Builder] [video] [12] transparent_layer create for d_move_layer BEGIN
# >> [AnimationMp4Builder] [video] [12] transparent_layer create for d_move_layer END
# >> [AnimationMp4Builder] [video] [12] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationMp4Builder] [video] [12] transparent_layer create for d_piece_layer END
# >> [AnimationMp4Builder] [video] [12] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationMp4Builder] [video] [12] transparent_layer create for d_piece_count_layer END
# >> [AnimationMp4Builder] [video] [12] composite process
# >> [AnimationMp4Builder] [video] @screen_image_renderer.next_build.write OK
# >> [AnimationMp4Builder] [video] 合計フレーム数(page_count): 13
# >> [AnimationMp4Builder] [video] ソース画像生成数: 13
# >> [AnimationMp4Builder] [video] [execute] ffmpeg -v warning -hide_banner -framerate 1000/1000 -i _input%04d.png -c:v libx264 -pix_fmt yuv420p -movflags +faststart  -y _output1.mp4
# >> [AnimationMp4Builder] [video] [execute] elapsed: 1s
# >> [AnimationMp4Builder] [video] -rw-r--r-- 1 ikeda staff 88K  9  7 09:10 _output1.mp4
# >> [AnimationMp4Builder] [video] [clear_all] @s_canvas_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @s_board_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @s_lattice_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @d_move_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @d_piece_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @d_piece_count_layer.destroy!
# >> [AnimationMp4Builder] [video] [clear_all] @last_rendered_image.destroy!
# >>   Stream #0:0(und): Video: h264 (High) (avc1 / 0x31637661), yuv420p, 1200x630, 54 kb/s, 1 fps, 1 tbr, 16384 tbn, 2 tbc (default)
# >> |------------------+----------------------------------------------------------------------------------------------------------------------|
# >> |         filename | _output.mp4                                                                                                          |
# >> |       nb_streams | 1                                                                                                                    |
# >> |      nb_programs | 0                                                                                                                    |
# >> |      format_name | mov,mp4,m4a,3gp,3g2,mj2                                                                                              |
# >> | format_long_name | QuickTime / MOV                                                                                                      |
# >> |       start_time | 0:00:00.000000                                                                                                       |
# >> |         duration | 0:00:13.000000                                                                                                       |
# >> |             size | 87.577148 Kibyte                                                                                                     |
# >> |         bit_rate | 55.187000 Kbit/s                                                                                                     |
# >> |      probe_score | 100                                                                                                                  |
# >> |             tags | {"major_brand"=>"isom", "minor_version"=>"512", "compatible_brands"=>"isomiso2avc1mp41", "encoder"=>"Lavf58.76.100"} |
# >> |------------------+----------------------------------------------------------------------------------------------------------------------|
