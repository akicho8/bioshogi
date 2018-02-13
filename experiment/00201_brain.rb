require "./example_helper"

mediator = Mediator.new
mediator.board.set_from_shape <<~EOT
+---------+
| ・ ・ ・|
| ・ ・ ・|
| ・ ・ 歩|
+---------+
EOT
puts mediator
mediator.player_at(:black).brain.all_hands.collect(&:to_kif)                               # => ["▲１二歩(13)", "▲１二歩成(13)"]
mediator.player_at(:black).brain.score_list.collect { |e| e.merge(hand: e[:hand].to_kif) } # => [{:hand=>"▲１二歩成(13)", :score=>1200}, {:hand=>"▲１二歩(13)", :score=>100}]

# >> 後手の持駒：なし
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|一
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|二
# >> | ・ ・ ・ ・ ・ ・ ・ ・ 歩|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# >> +---------------------------+
# >> 先手の持駒：なし
# >> 手数＝0 まで
