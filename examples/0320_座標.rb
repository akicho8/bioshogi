require "./example_helper"

# 座標の縦軸を「漢数字」での表現は禁止
Position::Hpos.parse("9")  # => #<Bushido::Position::Hpos:70287334993080 "9" 0>
Position::Hpos.parse("９") # => #<Bushido::Position::Hpos:70287334990560 "9" 0>
Position::Hpos.parse("九") rescue $! # => #<Bushido::PositionSyntaxError: "九" が ["9", "8", "7", "6", "5", "4", "3", "2", "1"] の中にありません>

Position::Vpos.parse("9")  # => #<Bushido::Position::Vpos:70287334978520 "九" 8>
Position::Vpos.parse("９") # => #<Bushido::Position::Vpos:70287334977180 "九" 8>
Position::Vpos.parse("九") # => #<Bushido::Position::Vpos:70287334975740 "九" 8>
