require "./setup"

DimensionColumn.fetch("1").left_spaces          # => 8
DimensionColumn.fetch("5").left_spaces          # => 4
DimensionColumn.fetch("9").left_spaces          # => 0

DimensionColumn.fetch("1").right_spaces         # => 0
DimensionColumn.fetch("5").right_spaces         # => 4
DimensionColumn.fetch("9").right_spaces         # => 8

DimensionColumn.fetch("1").x_is_two_to_eight?   # => false
DimensionColumn.fetch("2").x_is_two_to_eight?   # => true
DimensionColumn.fetch("3").x_is_two_to_eight?   # => true
DimensionColumn.fetch("4").x_is_two_to_eight?   # => true
DimensionColumn.fetch("5").x_is_two_to_eight?   # => true
DimensionColumn.fetch("6").x_is_two_to_eight?   # => true
DimensionColumn.fetch("7").x_is_two_to_eight?   # => true
DimensionColumn.fetch("8").x_is_two_to_eight?   # => true
DimensionColumn.fetch("9").x_is_two_to_eight?   # => false

DimensionColumn.fetch("1").x_is_two_or_eight?   # => false
DimensionColumn.fetch("2").x_is_two_or_eight?   # => true
DimensionColumn.fetch("3").x_is_two_or_eight?   # => false
DimensionColumn.fetch("4").x_is_two_or_eight?   # => false
DimensionColumn.fetch("5").x_is_two_or_eight?   # => false
DimensionColumn.fetch("6").x_is_two_or_eight?   # => false
DimensionColumn.fetch("7").x_is_two_or_eight?   # => false
DimensionColumn.fetch("8").x_is_two_or_eight?   # => true
DimensionColumn.fetch("9").x_is_two_or_eight?   # => false

DimensionColumn.fetch("1").x_is_three_to_seven? # => false
DimensionColumn.fetch("2").x_is_three_to_seven? # => false
DimensionColumn.fetch("3").x_is_three_to_seven? # => true
DimensionColumn.fetch("4").x_is_three_to_seven? # => true
DimensionColumn.fetch("5").x_is_three_to_seven? # => true
DimensionColumn.fetch("6").x_is_three_to_seven? # => true
DimensionColumn.fetch("7").x_is_three_to_seven? # => true
DimensionColumn.fetch("8").x_is_three_to_seven? # => false
DimensionColumn.fetch("9").x_is_three_to_seven? # => false

DimensionColumn.fetch("4").x_is_center?         # => false
DimensionColumn.fetch("5").x_is_center?         # => true
DimensionColumn.fetch("6").x_is_center?         # => false

DimensionColumn.fetch("1").x_is_edge?           # => true
DimensionColumn.fetch("2").x_is_edge?           # => false
DimensionColumn.fetch("8").x_is_edge?           # => false
DimensionColumn.fetch("9").x_is_edge?           # => true

DimensionColumn.fetch("4").x_is_right_area?     # => true
DimensionColumn.fetch("5").x_is_right_area?     # => false
DimensionColumn.fetch("6").x_is_right_area?     # => false

DimensionColumn.fetch("4").x_is_left_area?      # => false
DimensionColumn.fetch("5").x_is_left_area?      # => false
DimensionColumn.fetch("6").x_is_left_area?      # => true

DimensionColumn.fetch("1").x_is_right_edge?     # => true
DimensionColumn.fetch("2").x_is_right_edge?     # => false

DimensionColumn.fetch("8").x_is_left_edge?      # => false
DimensionColumn.fetch("9").x_is_left_edge?      # => true
