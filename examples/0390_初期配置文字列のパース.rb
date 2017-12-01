# 初期配置文字列のパース
require "./example_helper"

info = Soldier.from_str("７六と")
info[:piece].name # => "歩"
info[:promoted]   # => true
info[:point].name # => "７六"

pp info
tp info
# >> {:piece=><Bushido::Piece:70195378438040 歩 pawn>,
# >>  :promoted=>true,
# >>  :point=>#<Bushido::Point:70195379829320 "７六">}
# >> |----------+------|
# >> |    piece | 歩   |
# >> | promoted | true |
# >> |    point | ７六 |
# >> |----------+------|
