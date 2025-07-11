require "../setup"
info = Parser.parse(<<~EOT)
手合割：その他
上手の持駒：
+------+
| 飛v玉|
+------+
下手の持駒：金
下手番
下手：
上手：
手数----指手---------消費時間--
   1 11飛
EOT
p info
puts info.to_kif
