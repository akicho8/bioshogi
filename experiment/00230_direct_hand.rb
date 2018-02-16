require "./example_helper"

object = DirectHand.create(soldier: Soldier.from_str("▲６八銀"))
object.to_s    # => "▲６八銀打"
object.to_kif  # => "▲６八銀打"
object.to_csa  # => "+0068GI"
object.to_sfen # => "S*6h"
