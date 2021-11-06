require "./setup"

move_hand = MoveHand.create(soldier: Soldier.from_str("▲６八銀"), origin_soldier: Soldier.from_str("▲７九銀"))
object = HandLog.new(move_hand: move_hand, candidate_soldiers: [])
object.to_kif  # => "６八銀(79)"
object.to_ki2  # => "６八銀"
object.to_csa  # => "+7968GI"
object.to_sfen # => "7i6h"

drop_hand = DropHand.create(soldier: Soldier.from_str("▲６八銀"))
object = HandLog.new(drop_hand: drop_hand, candidate_soldiers: [])
object.to_kif  # => "６八銀打"
object.to_ki2  # => "６八銀"
object.to_csa  # => "+0068GI"
object.to_sfen # => "S*6h"
