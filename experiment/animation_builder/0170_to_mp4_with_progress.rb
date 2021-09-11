require "../example_helper"
sfen = "position startpos moves 7g7f 8c8d 7i6h 3c3d 6h7g"
info = Parser.parse(sfen)
info.to_mp4(end_duration_sec: 1, progress_callback: -> e { puts e[:log] })
# >> 2021-09-11 11:20:33 1/8  12.50 % T1 初期配置 0
# >> 2021-09-11 11:20:34 2/8  25.00 % T0 手数 1
# >> 2021-09-11 11:20:34 3/8  37.50 % T0 手数 2
# >> 2021-09-11 11:20:34 4/8  50.00 % T0 手数 3
# >> 2021-09-11 11:20:34 5/8  62.50 % T1 手数 4
# >> 2021-09-11 11:20:35 6/8  75.00 % T0 手数 5
# >> 2021-09-11 11:20:35 7/8  87.50 % T0 停止 6
