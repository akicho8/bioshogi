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
# mediator.execute("３四歩")
# mediator.execute("２二角成")
# mediator.player_at(:black).to_s_pieces # => "角"
# puts mediator

location = Location[:black]

static_board_info = StaticBoardInfo["カニ囲い"]

info = Utils.board_point_realize(location: location, both_board_info: static_board_info.both_board_info)
mini_soldiers = info[location]

# location 駒に絞って調べる
flag = mini_soldiers.all? do |e|
  if soldier = mediator.board[e[:point]]
    if soldier.player.location == location
      e == soldier.to_mini_soldier
    end
  end
end

flag                            # => true
