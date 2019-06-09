require "./example_helper"

parser = Parser.parse(<<~EOT, turn_limit: 10)
後手の持駒：飛二 角 銀二 桂四 香四 歩九
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・ ・v玉|一
| ・ ・ ・ ・ ・ ・ ・ 竜 ・|二
| ・ ・ ・ ・ ・ ・ ・ 歩 ・|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩v歩 歩v歩 歩v歩 歩v歩 歩|七
| ・ ・ ・ ・ ・ ・ ・ ・ ・|八
| ・ ・ ・ ・ 玉 ・ ・ ・ ・|九
+---------------------------+
先手の持駒：角 金四 銀二 歩九

６四角打
５三角打
32竜
EOT

object = parser.image_formatter
object.to_png[0..5]             # => "\x89PNG\r\n"
object.display
