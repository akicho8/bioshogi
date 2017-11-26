require "./example_helper"

mediator = Mediator.new
mediator.board_reset(<<~EOT)
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金v銀v桂v香|一
| ・v飛 ・ ・ ・ ・ ・v角 ・|二
|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ 歩 歩 歩 ・ ・ ・ ・|六
| ・ ・ ・ ・ ・ ・ ・ ・ ・|七
| ・ 角 金 銀 金 ・ ・ ・ ・|八
| ・ ・ ・ 玉 ・ ・ ・ ・ ・|九
+---------------------------+
  EOT

location = Location[:black]

static_board_info = StaticBoardInfo["カニ囲い"]
mini_soldiers = static_board_info.board_parser.mini_soldiers.collect do |e|
  e.merge(point: e[:point].reverse_if_white_location(location), location: location)
end

# location 駒に絞って調べる
flag = mini_soldiers.all? do |e|
  if soldier = mediator.board[e[:point]]
    e == soldier.to_mini_soldier
  end
end

flag                            # => true
