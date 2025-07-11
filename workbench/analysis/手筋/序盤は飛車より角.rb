require "#{__dir__}/setup"
info = Parser.parse(<<~EOT)
棋戦：共有将棋盤
後手の持駒：なし
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・ ・ ・v銀 ・ ・ |
| ・ ・ ・ ・ ・ ・ ・v角 ・ |
| ・ ・ ・ ・ ・ ・ ・ ・ ・ |
| ・ ・ ・ ・ ・ ・ ・ ・ ・ |
| ・ ・ ・ ・ ・ ・ ・ ・ ・ |
| ・ ・ ・ ・ ・ ・ ・ ・ ・ |
| ・ ・ ・ ・ ・ ・ ・ ・ ・ |
| ・ ・ ・ ・ ・ ・ ・ 飛 ・ |
| ・ ・ ・ ・ ・ ・ ・ ・ ・ |
+---------------------------+
先手の持駒：なし
先手番

22飛成 同銀

EOT
puts info.to_kif
# >> ["/Users/ikeda/src/bioshogi/lib/bioshogi/analysis/kakukiri_detector2.rb:48", :call, 1]
# >> ["/Users/ikeda/src/bioshogi/lib/bioshogi/analysis/kakukiri_detector2.rb:49", :call, 1]
# >> ["/Users/ikeda/src/bioshogi/lib/bioshogi/analysis/kakukiri_detector2.rb:50", :call, {rook: 1}]
# >> ["/Users/ikeda/src/bioshogi/lib/bioshogi/analysis/kakukiri_detector2.rb:51", :call, {rook: 1}]
# >> ["/Users/ikeda/src/bioshogi/lib/bioshogi/analysis/kakukiri_detector2.rb:52", :call, {bishop: 1}]
# >> true
# >> 棋戦：共有将棋盤
# >> 先手の手筋：序盤は飛車より角
# >> 先手の駒使用：歩0 銀0 金0 飛1 角0 玉0 桂0 香0 馬0 龍0 と0 圭0 全0 杏0
# >> 先手の玉移動：0回
# >> 先手のキル数：1キル
# >> 後手の駒使用：歩0 銀1 金0 飛0 角0 玉0 桂0 香0 馬0 龍0 と0 圭0 全0 杏0
# >> 後手の玉移動：0回
# >> 後手のキル数：1キル
# >> 接触：0手目
# >> 開戦：1手目
# >> 総手数：2手
# >> 総キル数：2キル
# >> 結末：投了
# >> 後手の持駒：なし
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・ ・ ・ ・ ・v銀 ・ ・|一
# >> | ・ ・ ・ ・ ・ ・ ・v角 ・|二
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# >> | ・ ・ ・ ・ ・ ・ ・ 飛 ・|八
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# >> +---------------------------+
# >> 先手の持駒：なし
# >> 先手番
# >> 手数----指手---------消費時間--
# >>    1 ２二飛成(28)
# >> *▲手筋：序盤は飛車より角
# >>    2 ２二銀(31)
# >>    3 投了
# >> まで2手で後手の勝ち
