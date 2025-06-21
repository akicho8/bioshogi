require "#{__dir__}/setup"

Soldier.from_str("▲41歩").align_arrow # => :right
Soldier.from_str("△41歩").align_arrow # => :left
Soldier.from_str("▲51歩").align_arrow # => :left
Soldier.from_str("△51歩").align_arrow # => :left
Soldier.from_str("▲61歩").align_arrow # => :left
Soldier.from_str("△61歩").align_arrow # => :right

Soldier.from_str("▲41歩").column_spaces_min # => 3
Soldier.from_str("△41歩").column_spaces_min # => 3
Soldier.from_str("▲51歩").column_spaces_min # => 4
Soldier.from_str("△51歩").column_spaces_min # => 4
Soldier.from_str("▲61歩").column_spaces_min # => 3
Soldier.from_str("△61歩").column_spaces_min # => 3
