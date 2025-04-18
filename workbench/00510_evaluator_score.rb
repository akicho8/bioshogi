require "./setup"

container = Container::Basic.new
container.players.collect { |e| e.evaluator.score } # => [0, 0]

container.board.placement_from_human("▲９七歩")
container.players.collect { |e| e.evaluator.score } # => [100, -100]

container.board.placement_from_human("▲９七歩 △１三歩")
container.players.collect { |e| e.evaluator.score } # => [0, 0]

container = Container::Basic.new
container.placement_from_bod <<~EOT
後手の持駒：
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・v銀v玉 ・ ・ ・ ・ ・|一
| ・ ・ ・ ・ ・ ・ ・ ・ ・|二
| ・ ・ ・ ・ 角 ・ ・ ・ ・|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| ・ ・ ・ ・v角 ・ ・ ・ ・|七
| ・ ・ ・ ・ ・ ・ ・ ・ ・|八
| ・ ・ 銀 ・ 玉 ・ 銀 ・ ・|九
+---------------------------+
先手の持駒：
EOT
puts container
tp container.player_at(:black).evaluator.detail_score
container.player_at(:black).evaluator.score # => 1000
container.player_at(:white).evaluator.score # => -1000
# >> 後手の持駒：なし
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・v銀v玉 ・ ・ ・ ・ ・|一
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|二
# >> | ・ ・ ・ ・ 角 ・ ・ ・ ・|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | ・ ・ ・ ・v角 ・ ・ ・ ・|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | ・ ・ 銀 ・ 玉 ・ 銀 ・ ・|九
# >> +---------------------------+
# >> 先手の持駒：なし
# >> 手数＝0 まで
# >>
# >> 先手番
# >> |----------+-------+--------+--------|
# >> | piece    | count | weight | total  |
# >> |----------+-------+--------+--------|
# >> | ▲５三角 |     1 |   1800 |   1800 |
# >> | ▲７九銀 |     1 |   1000 |   1000 |
# >> | ▲５九玉 |     1 |  40000 |  40000 |
# >> | ▲３九銀 |     1 |   1000 |   1000 |
# >> | △７一銀 |     1 |   1000 |  -1000 |
# >> | △６一玉 |     1 |  40000 | -40000 |
# >> | △５七角 |     1 |   1800 |  -1800 |
# >> |          |       |        |   1000 |
# >> |----------+-------+--------+--------|
