require "./setup"

DimensionColumn.fetch("1").left_spaces          # => 8
DimensionColumn.fetch("5").left_spaces          # => 4
DimensionColumn.fetch("9").left_spaces          # => 0

DimensionColumn.fetch("1").right_spaces         # => 0
DimensionColumn.fetch("5").right_spaces         # => 4
DimensionColumn.fetch("9").right_spaces         # => 8

DimensionColumn.fetch("1").column_is_two_to_eight?   # => false
DimensionColumn.fetch("2").column_is_two_to_eight?   # => true
DimensionColumn.fetch("3").column_is_two_to_eight?   # => true
DimensionColumn.fetch("4").column_is_two_to_eight?   # => true
DimensionColumn.fetch("5").column_is_two_to_eight?   # => true
DimensionColumn.fetch("6").column_is_two_to_eight?   # => true
DimensionColumn.fetch("7").column_is_two_to_eight?   # => true
DimensionColumn.fetch("8").column_is_two_to_eight?   # => true
DimensionColumn.fetch("9").column_is_two_to_eight?   # => false

DimensionColumn.fetch("1").column_is_two_or_eight?   # => false
DimensionColumn.fetch("2").column_is_two_or_eight?   # => true
DimensionColumn.fetch("3").column_is_two_or_eight?   # => false
DimensionColumn.fetch("4").column_is_two_or_eight?   # => false
DimensionColumn.fetch("5").column_is_two_or_eight?   # => false
DimensionColumn.fetch("6").column_is_two_or_eight?   # => false
DimensionColumn.fetch("7").column_is_two_or_eight?   # => false
DimensionColumn.fetch("8").column_is_two_or_eight?   # => true
DimensionColumn.fetch("9").column_is_two_or_eight?   # => false

DimensionColumn.fetch("1").column_is_three_to_seven? # => false
DimensionColumn.fetch("2").column_is_three_to_seven? # => false
DimensionColumn.fetch("3").column_is_three_to_seven? # => true
DimensionColumn.fetch("4").column_is_three_to_seven? # => true
DimensionColumn.fetch("5").column_is_three_to_seven? # => true
DimensionColumn.fetch("6").column_is_three_to_seven? # => true
DimensionColumn.fetch("7").column_is_three_to_seven? # => true
DimensionColumn.fetch("8").column_is_three_to_seven? # => false
DimensionColumn.fetch("9").column_is_three_to_seven? # => false

DimensionColumn.fetch("4").column_is_center?         # => false
DimensionColumn.fetch("5").column_is_center?         # => true
DimensionColumn.fetch("6").column_is_center?         # => false

DimensionColumn.fetch("1").column_is_edge?           # => true
DimensionColumn.fetch("2").column_is_edge?           # => false
DimensionColumn.fetch("8").column_is_edge?           # => false
DimensionColumn.fetch("9").column_is_edge?           # => true

DimensionColumn.fetch("4").column_is_right_area?     # => true
DimensionColumn.fetch("5").column_is_right_area?     # => false
DimensionColumn.fetch("6").column_is_right_area?     # => false

DimensionColumn.fetch("4").column_is_left_area?      # => false
DimensionColumn.fetch("5").column_is_left_area?      # => false
DimensionColumn.fetch("6").column_is_left_area?      # => true

DimensionColumn.fetch("1").column_is_right_edge?     # => true
DimensionColumn.fetch("2").column_is_right_edge?     # => false

DimensionColumn.fetch("8").column_is_left_edge?      # => false
DimensionColumn.fetch("9").column_is_left_edge?      # => true
