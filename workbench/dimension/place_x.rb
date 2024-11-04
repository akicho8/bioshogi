require "./setup"
Dimension::PlaceX.fetch("7").left_spaces(Location[:black])          # => 2
Dimension::PlaceX.fetch("7").right_spaces(Location[:black])          # => 6
Dimension::PlaceX.fetch("7").left_spaces(Location[:white])          # => 6
Dimension::PlaceX.fetch("7").right_spaces(Location[:white])          # => 2
