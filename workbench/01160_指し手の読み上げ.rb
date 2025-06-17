require "#{__dir__}/setup"

container = Container::Basic.new
container.placement_from_bod(<<~EOT)
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
container.execute("68銀")
container.hand_logs.last.yomiage      # => "したて、 6  8 ぎん"
container.execute("56飛打")
container.hand_logs.last.yomiage      # => "うわて、ごー 6 ひしゃ"
container.execute("34銀成")
container.hand_logs.last.yomiage      # => "したて、 3  4 ぎん成り"
container.execute("88角成")
container.hand_logs.last.yomiage      # => "うわて、 8  8 かく成り"
container.execute("53銀不成")
container.hand_logs.last.yomiage      # => "したて、ごー 3 ぎん不成"
container.execute("同成銀")
container.hand_logs.last.yomiage      # => "うわて、同、成り銀"
