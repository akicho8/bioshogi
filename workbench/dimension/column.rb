require "#{__dir__}/setup"

Column.fetch("1").left_space          # => 8
Column.fetch("5").left_space          # => 4
Column.fetch("9").left_space          # => 0

Column.fetch("1").right_space         # => 0
Column.fetch("5").right_space         # => 4
Column.fetch("9").right_space         # => 8

Column.fetch("4").left_right_space_min # => 3
Column.fetch("5").left_right_space_min # => 4
Column.fetch("6").left_right_space_min # => 3

Column.fetch("4").left_or_right # => :right
Column.fetch("5").left_or_right # => :left
Column.fetch("6").left_or_right # => :left

Column.fetch("1").column_eq?(2)   # => false
Column.fetch("2").column_eq?(2)   # => true
Column.fetch("3").column_eq?(2)   # => false

Column.fetch("1").column_is2to8?   # => false
Column.fetch("2").column_is2to8?   # => true
Column.fetch("3").column_is2to8?   # => true
Column.fetch("4").column_is2to8?   # => true
Column.fetch("5").column_is2to8?   # => true
Column.fetch("6").column_is2to8?   # => true
Column.fetch("7").column_is2to8?   # => true
Column.fetch("8").column_is2to8?   # => true
Column.fetch("9").column_is2to8?   # => false

Column.fetch("1").column_is2or8?   # => false
Column.fetch("2").column_is2or8?   # => true
Column.fetch("3").column_is2or8?   # => false
Column.fetch("4").column_is2or8?   # => false
Column.fetch("5").column_is2or8?   # => false
Column.fetch("6").column_is2or8?   # => false
Column.fetch("7").column_is2or8?   # => false
Column.fetch("8").column_is2or8?   # => true
Column.fetch("9").column_is2or8?   # => false

Column.fetch("1").column_is3to7? # => false
Column.fetch("2").column_is3to7? # => false
Column.fetch("3").column_is3to7? # => true
Column.fetch("4").column_is3to7? # => true
Column.fetch("5").column_is3to7? # => true
Column.fetch("6").column_is3to7? # => true
Column.fetch("7").column_is3to7? # => true
Column.fetch("8").column_is3to7? # => false
Column.fetch("9").column_is3to7? # => false

Column.fetch("4").column_is5?         # => false
Column.fetch("5").column_is5?         # => true
Column.fetch("6").column_is5?         # => false

Column.fetch("1").side_edge?           # => true
Column.fetch("2").side_edge?           # => false
Column.fetch("8").side_edge?           # => false
Column.fetch("9").side_edge?           # => true

Column.fetch("4").right_side?     # => true
Column.fetch("5").right_side?     # => false
Column.fetch("6").right_side?     # => false

Column.fetch("4").left_side?      # => false
Column.fetch("5").left_side?      # => false
Column.fetch("6").left_side?      # => true

Column.fetch("1").right_edge?     # => true
Column.fetch("2").right_edge?     # => false

Column.fetch("8").left_edge?      # => false
Column.fetch("9").left_edge?      # => true
