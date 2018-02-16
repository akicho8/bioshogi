require "./example_helper"

moved_hand = MoveHand.create(soldier: Soldier.from_str("▲６八銀"), origin_soldier: Soldier.from_str("▲７九銀"))
object = HandLog.new(moved_hand: moved_hand, candidate: [])
object.to_kif  # => "６八銀(79)"
object.to_ki2  # => "６八銀"
object.to_csa  # => "+7968GI"
object.to_sfen # => "7i6h"

direct_hand = DirectHand.create(soldier: Soldier.from_str("▲６八銀"))
object = HandLog.new(direct_hand: direct_hand, candidate: [])
object.to_kif  # => "６八銀打"
object.to_ki2  # => "６八銀"
object.to_csa  # => "+0068GI"
object.to_sfen # => "S*6h"
