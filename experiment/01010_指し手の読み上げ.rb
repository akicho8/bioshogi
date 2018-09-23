require "./example_helper"

mediator = Mediator.new
mediator.placement_from_bod(<<~EOT)
後手の持駒：飛
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金v銀v桂v香|一
| ・v飛 ・ ・ ・ ・ ・v角 ・|二
|v歩v歩v歩v歩v歩v歩v歩 銀v歩|三
| ・ ・ ・ ・ 銀 ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 歩 歩 歩 歩 歩 ・ 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 ・ 桂 香|九
+---------------------------+
先手の持駒：なし
手数＝0

後手番
EOT
mediator.execute("68銀")
mediator.hand_logs.last.hand.to_kifuyomi # => "先手、ろくはちぎん"
mediator.execute("55飛")
mediator.hand_logs.last.hand.to_kifuyomi # => "後手、ごーごーひしゃ打つ！"
mediator.execute("34銀成")
mediator.hand_logs.last.hand.to_kifuyomi # => "先手、さんよんぎん成り"
mediator.execute("57飛成")
mediator.hand_logs.last.hand.to_kifuyomi # => "後手、ごーななひしゃ成り"
mediator.execute("53銀不成")
mediator.hand_logs.last.hand.to_kifuyomi # => "先手、ごーさんぎん"
