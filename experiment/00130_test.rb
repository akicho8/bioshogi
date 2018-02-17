require "./example_helper"

mediator = Mediator.test1(init: "▲１五玉 ▲１四歩 △１一玉 △１二歩", exec: ["１三歩成", "１三歩"])
puts mediator

# mediator.opponent_player.executor.killed_soldier.name # => "歩"
# mediator.opponent_player.piece_box.to_s           # => "玉 飛 角 金二 銀二 桂二 香二 歩一〇"
# mediator.opponent_player.to_s_soldiers            # => "１一玉 １三歩"
# mediator.current_player.piece_box.to_s        # => "玉 飛 角 金二 銀二 桂二 香二 歩九"
# mediator.current_player.to_s_soldiers         # => "１五玉"
# >> 後手の持駒：歩
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・ ・ ・ ・ ・ ・ ・v玉|一
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|二
# >> | ・ ・ ・ ・ ・ ・ ・ ・v歩|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ 玉|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# >> +---------------------------+
# >> 先手の持駒：なし
# >> 手数＝2 △１三歩(12) まで
