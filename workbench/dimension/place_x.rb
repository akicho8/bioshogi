require "./setup"

PlaceX.fetch("1").left_spaces          # => 8
PlaceX.fetch("5").left_spaces          # => 4
PlaceX.fetch("9").left_spaces          # => 0

PlaceX.fetch("1").right_spaces         # => 0
PlaceX.fetch("5").right_spaces         # => 4
PlaceX.fetch("9").right_spaces         # => 8

PlaceX.fetch("1").x_is_two_to_eight?   # => false
PlaceX.fetch("2").x_is_two_to_eight?   # => true
PlaceX.fetch("3").x_is_two_to_eight?   # => true
PlaceX.fetch("4").x_is_two_to_eight?   # => true
PlaceX.fetch("5").x_is_two_to_eight?   # => true
PlaceX.fetch("6").x_is_two_to_eight?   # => true
PlaceX.fetch("7").x_is_two_to_eight?   # => true
PlaceX.fetch("8").x_is_two_to_eight?   # => true
PlaceX.fetch("9").x_is_two_to_eight?   # => false

PlaceX.fetch("1").x_is_two_or_eight?   # => false
PlaceX.fetch("2").x_is_two_or_eight?   # => true
PlaceX.fetch("3").x_is_two_or_eight?   # => false
PlaceX.fetch("4").x_is_two_or_eight?   # => false
PlaceX.fetch("5").x_is_two_or_eight?   # => false
PlaceX.fetch("6").x_is_two_or_eight?   # => false
PlaceX.fetch("7").x_is_two_or_eight?   # => false
PlaceX.fetch("8").x_is_two_or_eight?   # => true
PlaceX.fetch("9").x_is_two_or_eight?   # => false

PlaceX.fetch("1").x_is_three_to_seven? # => false
PlaceX.fetch("2").x_is_three_to_seven? # => false
PlaceX.fetch("3").x_is_three_to_seven? # => true
PlaceX.fetch("4").x_is_three_to_seven? # => true
PlaceX.fetch("5").x_is_three_to_seven? # => true
PlaceX.fetch("6").x_is_three_to_seven? # => true
PlaceX.fetch("7").x_is_three_to_seven? # => true
PlaceX.fetch("8").x_is_three_to_seven? # => false
PlaceX.fetch("9").x_is_three_to_seven? # => false

PlaceX.fetch("4").x_is_center?         # => false
PlaceX.fetch("5").x_is_center?         # => true
PlaceX.fetch("6").x_is_center?         # => false

PlaceX.fetch("1").x_is_edge?           # => true
PlaceX.fetch("2").x_is_edge?           # => false
PlaceX.fetch("8").x_is_edge?           # => false
PlaceX.fetch("9").x_is_edge?           # => true

PlaceX.fetch("4").x_is_right_area?     # => true
PlaceX.fetch("5").x_is_right_area?     # => false
PlaceX.fetch("6").x_is_right_area?     # => false

PlaceX.fetch("4").x_is_left_area?      # => false
PlaceX.fetch("5").x_is_left_area?      # => false
PlaceX.fetch("6").x_is_left_area?      # => true

PlaceX.fetch("1").x_is_right_edge?     # => true
PlaceX.fetch("2").x_is_right_edge?     # => false

PlaceX.fetch("8").x_is_left_edge?      # => false
PlaceX.fetch("9").x_is_left_edge?      # => true
