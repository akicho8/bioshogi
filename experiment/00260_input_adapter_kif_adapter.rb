require "./example_helper"

mediator = Mediator.start
player = mediator.player_at(:black)
player_executor = PlayerExecutor.new(player, "▲６八銀")
tp player_executor.input.to_h
player_executor.execute
puts mediator
# >> |-----------------+-------|
# >> |      point_from |       |
# >> |           point | ６八  |
# >> |           piece | 銀    |
# >> |        promoted | false |
# >> | promote_trigger | false |
# >> |  direct_trigger | false |
# >> |-----------------+-------|
# >> 後手の持駒：なし
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> |v香v桂v銀v金v玉v金v銀v桂v香|一
# >> | ・v飛 ・ ・ ・ ・ ・v角 ・|二
# >> |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
# >> | ・ 角 ・ 銀 ・ ・ ・ 飛 ・|八
# >> | 香 桂 ・ 金 玉 金 銀 桂 香|九
# >> +---------------------------+
# >> 先手の持駒：なし
# >> 手数＝0 まで
