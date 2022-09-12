require "./setup"

xcontainer = Xcontainer.new
xcontainer.placement_from_bod(<<~EOT)
上手の持駒：飛
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金v銀v桂v香|一
| ・ ・ ・ ・v全 ・ ・v角 ・|二
|v歩 ・v歩v歩v歩v歩 ・ 銀v歩|三
| ・ ・ ・ ・ 銀 ・ ・ ・ ・|四
| ・v飛 ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 ・ 歩 歩 歩 歩 ・ 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 ・ 桂 香|九
+---------------------------+
下手の持駒：なし
手数＝1

後手番
EOT
xcontainer.execute("68銀")
xcontainer.hand_logs.last.yomiage      # => "したて、 6  8 ぎん"
xcontainer.execute("56飛打")
xcontainer.hand_logs.last.yomiage      # => "うわて、ごー 6 ひしゃ"
xcontainer.execute("34銀成")
xcontainer.hand_logs.last.yomiage      # => "したて、 3  4 ぎん成り"
xcontainer.execute("88角成")
xcontainer.hand_logs.last.yomiage      # => "うわて、 8  8 かく成り"
xcontainer.execute("53銀不成")
xcontainer.hand_logs.last.yomiage      # => "したて、ごー 3 ぎん不成"
xcontainer.execute("同成銀")
xcontainer.hand_logs.last.yomiage      # => "うわて、同、成り銀"
