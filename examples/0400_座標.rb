require "./example_helper"

Position::Hpos.units # => ["９", "８", "７", "６", "５", "４", "３", "２", "１"]

Position::Hpos.parse("9")  # => #<Bushido::Position::Hpos:70264247640940 "９" 0>
Position::Hpos.parse("９") # => #<Bushido::Position::Hpos:70264247631200 "９" 0>
Position::Hpos.parse("九") # => #<Bushido::Position::Hpos:70264247630160 "９" 0>

Position::Vpos.parse("9")  # => #<Bushido::Position::Vpos:70264247626280 "九" 8>
Position::Vpos.parse("９") # => #<Bushido::Position::Vpos:70264247625540 "九" 8>
Position::Vpos.parse("九") # => #<Bushido::Position::Vpos:70264247624420 "九" 8>
