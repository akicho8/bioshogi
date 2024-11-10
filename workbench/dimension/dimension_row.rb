require "./setup"

DimensionRow.fetch("1").top_spaces    # => 0
DimensionRow.fetch("5").top_spaces    # => 4
DimensionRow.fetch("9").top_spaces    # => 8

DimensionRow.fetch("1").bottom_spaces # => 8
DimensionRow.fetch("5").bottom_spaces # => 4
DimensionRow.fetch("9").bottom_spaces # => 0

DimensionRow.fetch("3").opp_side?     # => true
DimensionRow.fetch("4").opp_side?     # => false

DimensionRow.fetch("3").not_opp_side? # => false
DimensionRow.fetch("4").not_opp_side? # => true

DimensionRow.fetch("6").own_side?     # => false
DimensionRow.fetch("7").own_side?     # => true

DimensionRow.fetch("6").not_own_side? # => true
DimensionRow.fetch("7").not_own_side? # => false

DimensionRow.fetch("5").kurai_sasae?  # => false
DimensionRow.fetch("6").kurai_sasae?  # => true

DimensionRow.fetch("2").just_nyuugyoku?     # => false
DimensionRow.fetch("3").just_nyuugyoku?     # => true
DimensionRow.fetch("4").just_nyuugyoku?     # => false

DimensionRow.fetch("3").atoippo_nyuugyoku?     # => false
DimensionRow.fetch("4").atoippo_nyuugyoku?     # => true
DimensionRow.fetch("5").atoippo_nyuugyoku?     # => false

DimensionRow.fetch("1").tarefu_desuka? # => false
DimensionRow.fetch("2").tarefu_desuka? # => true
DimensionRow.fetch("3").tarefu_desuka? # => true
DimensionRow.fetch("4").tarefu_desuka? # => true
DimensionRow.fetch("5").tarefu_desuka? # => false
