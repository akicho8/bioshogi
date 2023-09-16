require "./setup"

container = Container::Basic.new
container.placement_from_bod(<<~EOT)
後手の持駒：歩 角
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| 飛 と ・ ・ 玉 ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| 歩 ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
|v歩 ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
|v飛vとvと ・v玉 ・ ・ ・ ・|
+---------------------------+
先手の持駒：歩歩
手数＝2
EOT
container.player_at(:black).ek_score1 # => 8
container.player_at(:black).ek_score2 # => nil
container.player_at(:white).ek_score1 # => 13
container.player_at(:white).ek_score2 # => nil
