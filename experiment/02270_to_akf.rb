require "./setup"

info = Parser.parse("先手：alice\n先手の持駒：銀\n\n68銀 34歩 76歩 88角不成 55銀打 55角成")
tp info.to_akf[:header]
# tp info.to_akf[:moves][0]
# tp info.to_akf[:moves][1]
tp info.to_akf[:moves].first
tp info.to_akf[:moves].drop(1)
tp info.to_akf.except(:moves)
# >> |----------------------+----------------------------------|
# >> |                 先手 | alice                            |
# >> |           先手の持駒 | 銀                               |
# >> |           先手の囲い | 居玉                             |
# >> |           後手の囲い | 居玉                             |
# >> |           先手の戦型 | 嬉野流                           |
# >> |           先手の備考 | 居飛車, 相居飛車, 相居玉         |
# >> |           後手の備考 | 角不成, 居飛車, 相居飛車, 相居玉 |
# >> |                 手数 | 6                                |
# >> | last_action_kakinoki_word | 投了                             |
# >> |     judgment_message | まで6手で後手の勝ち              |
# >> |           error_text |                                  |
# >> |----------------------+----------------------------------|
# >> |---------------+-------------------------------------------------------------------------------|
# >> |         index | 0                                                                             |
# >> |   human_index | 0                                                                             |
# >> |    place_same |                                                                               |
# >> | total_seconds | 0                                                                             |
# >> |  used_seconds |                                                                               |
# >> |         skill |                                                                               |
# >> |  history_sfen | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S 1 |
# >> | snapshot_sfen | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S 1 |
# >> |---------------+-------------------------------------------------------------------------------|
# >> |-------+-------------+------------+-----------+-----------------+--------+----------+----------------+----------------+--------------------------------------------------------------------------------+-------+----------------+---------+---------------+--------------+--------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------|
# >> | index | human_index | place_same | _location | type            | piece  | promoted | from           | to             | captured                                                                       | _sfen | _kif           | _csa    | total_seconds | used_seconds | skill                                                  | history_sfen                                                                                                       | snapshot_sfen                                                                       |
# >> |-------+-------------+------------+-----------+-----------------+--------+----------+----------------+----------------+--------------------------------------------------------------------------------+-------+----------------+---------+---------------+--------------+--------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------|
# >> |     1 |           1 |            | black     | t_move          | silver | false    | {:x=>7, :y=>9} | {:x=>6, :y=>8} |                                                                                | 7i6h  | ▲６八銀(79)   | +7968GI |             0 |            0 | {:defense=>[], :attack=>[], :technique=>[], :note=>[]} | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S 1 moves 7i6h                           | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL w S 2     |
# >> |     2 |           2 | false      | white     | t_move          | pawn   | false    | {:x=>3, :y=>3} | {:x=>3, :y=>4} |                                                                                | 3c3d  | △３四歩(33)   | -3334FU |             0 |            0 | {:defense=>[], :attack=>[], :technique=>[], :note=>[]} | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S 1 moves 7i6h 3c3d                      | position sfen lnsgkgsnl/1r5b1/pppppp1pp/6p2/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL b S 3   |
# >> |     3 |           3 | false      | black     | t_move          | pawn   | false    | {:x=>7, :y=>7} | {:x=>7, :y=>6} |                                                                                | 7g7f  | ▲７六歩(77)   | +7776FU |             0 |            0 | {:defense=>[], :attack=>[], :technique=>[], :note=>[]} | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S 1 moves 7i6h 3c3d 7g7f                 | position sfen lnsgkgsnl/1r5b1/pppppp1pp/6p2/9/2P6/PP1PPPPPP/1B1S3R1/LN1GKGSNL w S 4 |
# >> |     4 |           4 | false      | white     | t_promote_throw | bishop | false    | {:x=>2, :y=>2} | {:x=>8, :y=>8} | {:piece=>:bishop, :promoted=>false, :place=>{:x=>8, :y=>8}, :location_info=>:black} | 2b8h  | △８八角(22)   | -2288KA |             0 |            0 | {:defense=>[], :attack=>[], :technique=>[], :note=>[]} | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S 1 moves 7i6h 3c3d 7g7f 2b8h            | position sfen lnsgkgsnl/1r7/pppppp1pp/6p2/9/2P6/PP1PPPPPP/1b1S3R1/LN1GKGSNL b Sb 5  |
# >> |     5 |           5 | false      | black     | t_drop          | silver |          |                | {:x=>5, :y=>5} |                                                                                | S*5e  | ▲５五銀打     | +0055GI |             0 |            0 | {:defense=>[], :attack=>[], :technique=>[], :note=>[]} | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S 1 moves 7i6h 3c3d 7g7f 2b8h S*5e       | position sfen lnsgkgsnl/1r7/pppppp1pp/6p2/4S4/2P6/PP1PPPPPP/1b1S3R1/LN1GKGSNL w b 6 |
# >> |     6 |           6 | true       | white     | t_promote_on    | bishop | false    | {:x=>8, :y=>8} | {:x=>5, :y=>5} | {:piece=>:silver, :promoted=>false, :place=>{:x=>5, :y=>5}, :location_info=>:black} | 8h5e+ | △５五角成(88) | -8855UM |             0 |            0 | {:defense=>[], :attack=>[], :technique=>[], :note=>[]} | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S 1 moves 7i6h 3c3d 7g7f 2b8h S*5e 8h5e+ | position sfen lnsgkgsnl/1r7/pppppp1pp/6p2/4+b4/2P6/PP1PPPPPP/3S3R1/LN1GKGSNL b bs 7 |
# >> |-------+-------------+------------+-----------+-----------------+--------+----------+----------------+----------------+--------------------------------------------------------------------------------+-------+----------------+---------+---------------+--------------+--------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------|
# >> |--------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> | header | {"先手"=>"alice", "先手の持駒"=>"銀", "先手の囲い"=>"居玉", "後手の囲い"=>"居玉", "先手の戦型"=>"嬉野流", "先手の備考"=>"居飛車, 相居飛車, 相居玉", "後手の備考"=>"角不成, 居飛車, 相居飛車, 相居玉", "手数"=>6, :last_action_kakinoki_word=>"投了", :judgment_message=>"まで6手で後手の勝ち", :error_text=>nil} |
# >> |--------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
