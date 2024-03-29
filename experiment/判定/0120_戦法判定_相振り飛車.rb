require "../setup"

info = Parser.parse(<<~EOT)
先手の戦型：▲７八飛戦法
後手の戦型：2手目△３ニ飛戦法, 相振り飛車
先手の備考：振り飛車, 相振り
後手の備考：振り飛車, 相振り
手合割：平手
手数----指手---------消費時間--
   1 ７八飛(28)
   2 ３二飛(82)
   3 投了
まで2手で後手の勝ち
EOT
# puts info.formatter.container
# tp info.formatter.container.players.first.attack_infos
# tp info.formatter.container.players.last.attack_infos
puts info.to_kif
# >> <相振り飛車>
# >> 先手の戦型：▲７八飛戦法, 相振り飛車
# >> 後手の戦型：2手目△３ニ飛戦法, 相振り飛車
# >> 先手の備考：振り飛車, 相振り
# >> 後手の備考：振り飛車, 相振り
# >> 手合割：平手
# >> 手数----指手---------消費時間--
# >>    1 ７八飛(28)
# >> *▲戦型：▲７八飛戦法
# >> *▲備考：振り飛車
# >>    2 ３二飛(82)
# >> *△戦型：2手目△３ニ飛戦法, 相振り飛車
# >> *△備考：振り飛車
# >>    3 投了
# >> まで2手で後手の勝ち
