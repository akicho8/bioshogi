require "./setup"

container = Container.create
container.placement_from_bod <<~EOT
後手の持駒：香
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・v桂v銀v金v玉v金v銀v桂v香|一
| ・v飛 ・ ・ ・ ・ ・v角 ・|二
|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
| ・ 角 ・ ・ ・ ・ ・ ・ ・|八
| 香 桂 銀 金 ・ 金 銀 桂 ・|九
+---------------------------+
先手の持駒：飛
EOT

# 足りない駒
container.not_enough_piece_box.to_s # => "玉 香"

# 玉の数は無視して足りない駒を調べる
piece_box = container.not_enough_piece_box
piece_box.delete(:king)
piece_box.to_s                  # => "香"
