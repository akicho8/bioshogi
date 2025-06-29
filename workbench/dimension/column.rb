require "#{__dir__}/setup"

Column.fetch("1").left_spaces          # => 8
Column.fetch("5").left_spaces          # => 4
Column.fetch("9").left_spaces          # => 0

Column.fetch("1").right_spaces         # => 0
Column.fetch("5").right_spaces         # => 4
Column.fetch("9").right_spaces         # => 8

Column.fetch("4").column_spaces_min # => 3
Column.fetch("5").column_spaces_min # => 4
Column.fetch("6").column_spaces_min # => 3

Column.fetch("4").align_arrow # => :right
Column.fetch("5").align_arrow # => :left
Column.fetch("6").align_arrow # => :left

Column.fetch("1").column_is2?   # => false
Column.fetch("2").column_is2?   # => true
Column.fetch("3").column_is2?   # => false

Column.fetch("1").column_is_second_to_eighth?   # => false
Column.fetch("2").column_is_second_to_eighth?   # => true
Column.fetch("3").column_is_second_to_eighth?   # => true
Column.fetch("4").column_is_second_to_eighth?   # => true
Column.fetch("5").column_is_second_to_eighth?   # => true
Column.fetch("6").column_is_second_to_eighth?   # => true
Column.fetch("7").column_is_second_to_eighth?   # => true
Column.fetch("8").column_is_second_to_eighth?   # => true
Column.fetch("9").column_is_second_to_eighth?   # => false

Column.fetch("1").column_is_second_or_eighth?   # => false
Column.fetch("2").column_is_second_or_eighth?   # => true
Column.fetch("3").column_is_second_or_eighth?   # => false
Column.fetch("4").column_is_second_or_eighth?   # => false
Column.fetch("5").column_is_second_or_eighth?   # => false
Column.fetch("6").column_is_second_or_eighth?   # => false
Column.fetch("7").column_is_second_or_eighth?   # => false
Column.fetch("8").column_is_second_or_eighth?   # => true
Column.fetch("9").column_is_second_or_eighth?   # => false

Column.fetch("1").column_is_three_to_seven? # => false
Column.fetch("2").column_is_three_to_seven? # => false
Column.fetch("3").column_is_three_to_seven? # => true
Column.fetch("4").column_is_three_to_seven? # => true
Column.fetch("5").column_is_three_to_seven? # => true
Column.fetch("6").column_is_three_to_seven? # => true
Column.fetch("7").column_is_three_to_seven? # => true
Column.fetch("8").column_is_three_to_seven? # => false
Column.fetch("9").column_is_three_to_seven? # => false

Column.fetch("4").column_is_center?         # => false
Column.fetch("5").column_is_center?         # => true
Column.fetch("6").column_is_center?         # => false

Column.fetch("1").column_is_edge?           # => true
Column.fetch("2").column_is_edge?           # => false
Column.fetch("8").column_is_edge?           # => false
Column.fetch("9").column_is_edge?           # => true

Column.fetch("4").column_is_right_side?     # => true
Column.fetch("5").column_is_right_side?     # => false
Column.fetch("6").column_is_right_side?     # => false

Column.fetch("4").column_is_left_side?      # => false
Column.fetch("5").column_is_left_side?      # => false
Column.fetch("6").column_is_left_side?      # => true

Column.fetch("1").column_is_right_edge?     # => true
Column.fetch("2").column_is_right_edge?     # => false

Column.fetch("8").column_is_left_edge?      # => false
Column.fetch("9").column_is_left_edge?      # => true
