require "./setup"

container = Container::Basic.new
container.placement_from_bod(<<~EOT)
後手の持駒：歩 角
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| 飛 と と と と ・ ・ ・ 玉|
| と と と と ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| 歩 ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
|v歩 ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
|vとvとvとvとvと ・ ・ ・ ・|
|v飛vとvとvとvと ・ ・ ・ v玉|
+---------------------------+
先手の持駒：歩歩
手数＝2
EOT
container.player_at(:black).ek_score_without_cond # => 15
container.player_at(:black).ek_score_with_cond # => nil
container.player_at(:white).ek_score_without_cond # => 20
container.player_at(:white).ek_score_with_cond # => 20
