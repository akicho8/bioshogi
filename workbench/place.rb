require "./setup"

Place[[9, 0]]                 # => nil

Place["１一"].to_xy             # => [8, 0]
Place["１一"] == Place["１一"]  # => true

a = Place["１一"]
b = Place["２一"]
[a, b]                          # => [#<Bioshogi::Place １一>, #<Bioshogi::Place ２一>]
[a, b].sort                     # => [#<Bioshogi::Place ２一>, #<Bioshogi::Place １一>]
[a, b].sort_by(&:to_xy)         # => [#<Bioshogi::Place ２一>, #<Bioshogi::Place １一>]

Place["１一"].object_id         # => 2040
Place["11"].object_id           # => 2040

# Dimension::PlaceX.fetch(1).object_id # => 70357212614280
# Dimension::PlaceX.fetch(1).object_id # => 70357212614280

Place["76"].hash                # => -3773589924383953812
Place["７６"].hash              # => -3773589924383953812
Place["76"].object_id           # => 2060
Place["７６"].object_id         # => 2060
hash = {}

hash[Place["76"]] = 1
hash[Place["７６"]]             # => 1

[1, 2].hash                     # => -3888008448451412462
[1, 2].hash                     # => -3888008448451412462

Place["13"].opp_side?(:black) # => true
Place["14"].opp_side?(:black) # => false
Place["16"].opp_side?(:white) # => false
Place["17"].opp_side?(:white) # => true
Place["13"].own_side?(:white) # => true
Place["14"].own_side?(:white) # => false
Place["16"].own_side?(:black) # => false
Place["17"].own_side?(:black) # => true

Place["55"].move_to_xy(Location[:black], 1, -1) # => #<Bioshogi::Place ４四>
Place["55"].move_to_xy(Location[:white], 1, -1) # => #<Bioshogi::Place ６六>

Place["15"].x_is_two_to_eight?    # => false
Place["25"].x_is_two_to_eight?    # => true
Place["85"].x_is_two_to_eight?    # => true
Place["95"].x_is_two_to_eight?    # => false

Place["13"].top_spaces(Location[:black])          # => 2
Place["13"].opp_side?(Location[:black])    # => true

place = Place["13"]             # => #<Bioshogi::Place １三>
Location[:black].bottom         # => #<Bioshogi::Dimension::PlaceY:2080 "九" 8>
Place[[place.x, Location[:black].bottom]] # => #<Bioshogi::Place １九>

place = Place["13"]             # => #<Bioshogi::Place １三>
Location[:black].bottom         # => #<Bioshogi::Dimension::PlaceY:2080 "九" 8>
Place[[place.x, Location[:white].bottom]] # => #<Bioshogi::Place １一>
