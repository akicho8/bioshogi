require "../setup"
info = Parser.parse(<<~EOT)
手合割：その他
上手の持駒：なし
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・v王 ・ ・ ・ ・|一
| ・v飛 ・ ・ ・ ・ ・v飛 ・|二
|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
| ・ ・ ・ ・ ・ ・ ・ ・ ・|八
| 香 桂 銀 金 玉 金 銀 桂 香|九
+---------------------------+
下手の持駒：なし
上手番
手数----指手---------消費時間--
   1 ４二玉(51)
EOT
p info
puts info.to_kif
# >> * pi.board_source
# >> +---------------------------+
# >> | ・ ・ ・ ・v王 ・ ・ ・ ・|一
# >> | ・v飛 ・ ・ ・ ・ ・v飛 ・|二
# >> |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | 香 桂 銀 金 玉 金 銀 桂 香|九
# >> +---------------------------+
# >>
# >> * attributes
# >> |-------------------+----|
# >> | force_preset_info |    |
# >> |    force_location | △ |
# >> |    force_handicap |    |
# >> |-------------------+----|
# >>
# >> * pi.header
# >> |--------+--------|
# >> | 手合割 | その他 |
# >> |--------+--------|
# >>
# >> * @parser.pi.board_source
# >> +---------------------------+
# >> | ・ ・ ・ ・v王 ・ ・ ・ ・|一
# >> | ・v飛 ・ ・ ・ ・ ・v飛 ・|二
# >> |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | 香 桂 銀 金 玉 金 銀 桂 香|九
# >> +---------------------------+
# >>
# >> * pi.move_infos
# >> |-------------+------------+------------+--------------|
# >> | turn_number | input      | clock_part | used_seconds |
# >> |-------------+------------+------------+--------------|
# >> |           1 | ４二玉(51) |            |              |
# >> |-------------+------------+------------+--------------|
# >>
# >> * @parser.pi.last_action_params
# >> 手合割：その他
# >> 先手の備考：居飛車, 相居飛車
# >> 後手の備考：居飛車, 相居飛車
# >> 後手の持駒：なし
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・ ・ ・v玉 ・ ・ ・ ・|一
# >> | ・v飛 ・ ・ ・ ・ ・v飛 ・|二
# >> |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | 香 桂 銀 金 玉 金 銀 桂 香|九
# >> +---------------------------+
# >> 先手の持駒：なし
# >> 後手番
# >> 手数----指手---------消費時間--
# >>    1 ４二玉(51)
# >>    2 投了
# >> まで1手で後手の勝ち
