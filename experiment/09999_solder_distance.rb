require "./example_helper"

Soldier.from_str("▲41歩").distance_to_wall_sign # => 1
Soldier.from_str("△41歩").distance_to_wall_sign # => 1
Soldier.from_str("▲51歩").distance_to_wall_sign # => -1
Soldier.from_str("△51歩").distance_to_wall_sign # => -1
Soldier.from_str("▲61歩").distance_to_wall_sign # => -1
Soldier.from_str("△61歩").distance_to_wall_sign # => -1

Soldier.from_str("▲41歩").smaller_one_of_distance_to_wall # => 3
Soldier.from_str("△41歩").smaller_one_of_distance_to_wall # => 3
Soldier.from_str("▲51歩").smaller_one_of_distance_to_wall # => 4
Soldier.from_str("△51歩").smaller_one_of_distance_to_wall # => 4
Soldier.from_str("▲61歩").smaller_one_of_distance_to_wall # => 3
Soldier.from_str("△61歩").smaller_one_of_distance_to_wall # => 3
