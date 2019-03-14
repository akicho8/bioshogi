require "./example_helper"

Soldier.from_str("▲41歩").sign_to_goto_closer_side # => 1
Soldier.from_str("△41歩").sign_to_goto_closer_side # => 1
Soldier.from_str("▲51歩").sign_to_goto_closer_side # => -1
Soldier.from_str("△51歩").sign_to_goto_closer_side # => -1
Soldier.from_str("▲61歩").sign_to_goto_closer_side # => -1
Soldier.from_str("△61歩").sign_to_goto_closer_side # => -1

Soldier.from_str("▲41歩").smaller_one_of_side_spaces # => 3
Soldier.from_str("△41歩").smaller_one_of_side_spaces # => 3
Soldier.from_str("▲51歩").smaller_one_of_side_spaces # => 4
Soldier.from_str("△51歩").smaller_one_of_side_spaces # => 4
Soldier.from_str("▲61歩").smaller_one_of_side_spaces # => 3
Soldier.from_str("△61歩").smaller_one_of_side_spaces # => 3
