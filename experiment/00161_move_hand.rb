require "./example_helper"

object = MoveHand.create(soldier: Soldier.from_str("▲６八銀"), origin_soldier: Soldier.from_str("▲７九銀"))
object.to_s    # => "▲６八銀(79)"
object.to_kif  # => "▲６八銀(79)"
object.to_csa  # => "+7968GI"
object.to_sfen # => "7i6h"
