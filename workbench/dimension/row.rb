require "./setup"

Row.fetch("4").distance_from_middle    # => 1
Row.fetch("5").distance_from_middle    # => 0
Row.fetch("6").distance_from_middle    # => 1

Row.fetch("1").top_spaces    # => 0
Row.fetch("5").top_spaces    # => 4
Row.fetch("9").top_spaces    # => 8

Row.fetch("1").bottom_spaces # => 8
Row.fetch("5").bottom_spaces # => 4
Row.fetch("9").bottom_spaces # => 0

Row.fetch("3").opp_side?     # => true
Row.fetch("4").opp_side?     # => false

Row.fetch("3").not_opp_side? # => false
Row.fetch("4").not_opp_side? # => true

Row.fetch("6").own_side?     # => false
Row.fetch("7").own_side?     # => true

Row.fetch("6").not_own_side? # => true
Row.fetch("7").not_own_side? # => false

Row.fetch("3").middle_row?          # => false
Row.fetch("4").middle_row?          # => true
Row.fetch("6").middle_row?          # => true
Row.fetch("7").middle_row?          # => false

Row.fetch("5").funoue_line_ni_uita?  # => false
Row.fetch("6").funoue_line_ni_uita?  # => true
Row.fetch("7").funoue_line_ni_uita?  # => false

Row.fetch("5").kurai_sasae?  # => false
Row.fetch("6").kurai_sasae?  # => true

Row.fetch("2").just_nyuugyoku?     # => false
Row.fetch("3").just_nyuugyoku?     # => true
Row.fetch("4").just_nyuugyoku?     # => false

Row.fetch("3").atoippo_nyuugyoku?     # => false
Row.fetch("4").atoippo_nyuugyoku?     # => true
Row.fetch("5").atoippo_nyuugyoku?     # => false

Row.fetch("1").tarefu_desuka? # => false
Row.fetch("2").tarefu_desuka? # => true
Row.fetch("3").tarefu_desuka? # => true
Row.fetch("4").tarefu_desuka? # => true
Row.fetch("5").tarefu_desuka? # => false
