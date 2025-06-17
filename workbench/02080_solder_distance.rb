require "#{__dir__}/setup"

Soldier.from_str("▲41歩").left_or_right_to_closer_side # => :right
Soldier.from_str("△41歩").left_or_right_to_closer_side # => :left
Soldier.from_str("▲51歩").left_or_right_to_closer_side # => :left
Soldier.from_str("△51歩").left_or_right_to_closer_side # => :left
Soldier.from_str("▲61歩").left_or_right_to_closer_side # => :left
Soldier.from_str("△61歩").left_or_right_to_closer_side # => :right

Soldier.from_str("▲41歩").column_spaces_min # => 3
Soldier.from_str("△41歩").column_spaces_min # => 3
Soldier.from_str("▲51歩").column_spaces_min # => 4
Soldier.from_str("△51歩").column_spaces_min # => 4
Soldier.from_str("▲61歩").column_spaces_min # => 3
Soldier.from_str("△61歩").column_spaces_min # => 3
