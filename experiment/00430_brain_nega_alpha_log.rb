# NegaMaxのログ表示

require "./example_helper"

Board.logger = ActiveSupport::Logger.new(STDOUT)
Board.dimensiton_change([3, 3]) do
  mediator = Mediator.new
  mediator.board.placement_from_human("▲３三歩 △１一歩")
  puts mediator
  object = NegaAlphaDiver.new(depth_max: 1, current_player: mediator.player_at(:black))
  puts object.dive
end
# >> 後手の持駒：なし
# >>   ３ ２ １
# >> +---------+
# >> | ・ ・v歩|一
# >> | ・ ・ ・|二
# >> | 歩 ・ ・|三
# >> +---------+
# >> 先手の持駒：なし
# >> 手数＝0 まで
# >> 
# >> 先手番
# >>     0 ▲ 試指 ▲３二歩成(33) (0)
# >>     1 △     評価 -1100
# >>     0 ▲ ★確 ▲３二歩成(33)
# >> 1100
# >> ▲３二歩成(33)
