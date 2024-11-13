# NegaMaxのログ表示

require "./setup"

Board.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
Dimension.change([3, 3]) do
  container = Container::Basic.new
  container.board.placement_from_human("▲３三歩 △１一歩")
  puts container
  object = AI::Diver::NegaAlphaDiver.new(depth_max: 1, current_player: container.player_at(:black))
  tp object.dive
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
# >>     0 ▲ ▲３二歩成(33)
# >>     1 △     -1100
# >>     0 ▲ ★確 ▲３二歩成(33) (1100)
# >> |--------------------|
# >> |               1100 |
# >> | [<▲３二歩成(33)>] |
# >> | []                 |
# >> |--------------------|
