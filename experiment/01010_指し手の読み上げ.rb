require "./example_helper"

mediator = Mediator.new
mediator.placement_from_bod(<<~EOT)
上手の持駒：飛
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金v銀v桂v香|一
| ・ ・ ・ ・v全 ・ ・v角 ・|二
|v歩 ・v歩v歩v歩v歩v歩 銀v歩|三
| ・ ・ ・ ・ 銀 ・ ・ ・ ・|四
| ・v飛 ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 歩 歩 歩 歩 歩 ・ 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 ・ 桂 香|九
+---------------------------+
下手の持駒：なし
手数＝1

後手番
EOT
mediator.execute("68銀")
mediator.hand_logs.last.hand.to_kifuyomi # => "せんて、ろくはちぎん"
mediator.hand_logs.last.to_ki2           # => "６八銀"
mediator.hand_logs.last.to_kifuyomi      # => "したて、ろくはちぎん"
mediator.execute("55飛打")
mediator.hand_logs.last.hand.to_kifuyomi # => "ごて、ごーごーひしゃ打つ！"
mediator.hand_logs.last.to_ki2           # => "５五飛打"
mediator.hand_logs.last.to_kifuyomi      # => "うわて、ごーごーひしゃうつ"
mediator.execute("34銀成")
mediator.hand_logs.last.hand.to_kifuyomi # => "せんて、さんよんぎん成り"
mediator.hand_logs.last.to_ki2           # => "３四銀成"
mediator.hand_logs.last.to_kifuyomi      # => "したて、さんよんぎんなり"
mediator.execute("57飛成")
mediator.hand_logs.last.hand.to_kifuyomi # => "ごて、ごーななひしゃ成り"
mediator.hand_logs.last.to_ki2           # => "５七飛成"
mediator.hand_logs.last.to_kifuyomi      # => "うわて、ごーななひしゃなり"
mediator.execute("53銀不成")
mediator.hand_logs.last.hand.to_kifuyomi # => "せんて、ごーさんぎん"
mediator.hand_logs.last.to_ki2           # => "５三銀不成"
mediator.hand_logs.last.to_kifuyomi      # => "したて、ごーさんぎんふなり"
mediator.execute("同成銀")
mediator.hand_logs.last.hand.to_kifuyomi # => "ごて、ごーさんなりぎん"
mediator.hand_logs.last.to_ki2           # => "同全"
mediator.hand_logs.last.to_kifuyomi      # => "うわて、どうなりぎん"
