require "#{__dir__}/setup"

Location[:black].bottom.name         # => "九"
Location[:black].top.name            # => "一"
Location[:black].right.name          # => "１"
Location[:black].left.name           # => "９"

Location[:white].bottom.name         # => "一"
Location[:white].top.name            # => "九"
Location[:white].left.name           # => "１"
Location[:white].right.name          # => "９"
