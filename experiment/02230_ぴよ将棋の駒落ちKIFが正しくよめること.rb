require "./example_helper"

str = "
手合割：その他
上手の持駒：なし
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・v銀v金v玉v金v銀 ・ ・|一
| ・ ・ ・ ・ ・ ・ ・ ・ ・|二
|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 銀 桂 香|九
+---------------------------+
下手の持駒：なし

上手番
手数----指手---------消費時間--
   1 ４二玉(51)
"
info = Parser.parse(str)
info.initial_mediator.turn_info                    # => #<駒落ち:0+0:△上手番>
info.initial_mediator.turn_info.current_location   # => <white>
info.initial_mediator.turn_info.location_call_name # => "上手"
puts info.to_kif
# >> 手合割：六枚落ち
# >> 下手の備考：居玉
# >> 手数----指手---------消費時間--
# >>    1 ４二玉(51)   (00:00/00:00:00)
# >>    2 投了
# >> まで1手で上手の勝ち
