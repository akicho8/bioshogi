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

Place["76"].hash                # => 3509947724978323174
Place["７６"].hash              # => 3509947724978323174
Place["76"].object_id           # => 2060
Place["７６"].object_id         # => 2060
hash = {}

hash[Place["76"]] = 1
hash[Place["７６"]]             # => 1

[1, 2].hash                     # => -1755251422519666414
[1, 2].hash                     # => -1755251422519666414

Place["13"].opponent_side?(:black) # => true
Place["14"].opponent_side?(:black) # => false
Place["16"].opponent_side?(:white) # => false
Place["17"].opponent_side?(:white) # => true
Place["13"].own_side?(:white) # => true
Place["14"].own_side?(:white) # => false
Place["16"].own_side?(:black) # => false
Place["17"].own_side?(:black) # => true

Place["55"].move_to_xy(1, -1, location: Location[:black]) # => #<Bioshogi::Place ４四>
Place["55"].move_to_xy(1, -1, location: Location[:white]) # => #<Bioshogi::Place ６六>

Place["15"].x_in_2_to_8?    # => false
Place["25"].x_in_2_to_8?    # => true
Place["85"].x_in_2_to_8?    # => true
Place["95"].x_in_2_to_8?    # => false

