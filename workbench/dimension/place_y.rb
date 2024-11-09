require "./setup"

PlaceY.fetch("1").top_spaces    # => 0
PlaceY.fetch("5").top_spaces    # => 4
PlaceY.fetch("9").top_spaces    # => 8

PlaceY.fetch("1").bottom_spaces # => 8
PlaceY.fetch("5").bottom_spaces # => 4
PlaceY.fetch("9").bottom_spaces # => 0

PlaceY.fetch("3").opp_side?     # => true
PlaceY.fetch("4").opp_side?     # => false

PlaceY.fetch("3").not_opp_side? # => false
PlaceY.fetch("4").not_opp_side? # => true

PlaceY.fetch("6").own_side?     # => false
PlaceY.fetch("7").own_side?     # => true

PlaceY.fetch("6").not_own_side? # => true
PlaceY.fetch("7").not_own_side? # => false

PlaceY.fetch("5").kurai_sasae?  # => false
PlaceY.fetch("6").kurai_sasae?  # => true

PlaceY.fetch("2").sandanme?     # => false
PlaceY.fetch("3").sandanme?     # => true
PlaceY.fetch("4").sandanme?     # => false

PlaceY.fetch("3").yondanme?     # => false
PlaceY.fetch("4").yondanme?     # => true
PlaceY.fetch("5").yondanme?     # => false
