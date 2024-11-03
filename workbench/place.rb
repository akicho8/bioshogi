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

Place["76"].hash                # => 3901944702000124990
Place["７６"].hash              # => 3901944702000124990
Place["76"].object_id           # => 2060
Place["７６"].object_id         # => 2060
hash = {}

hash[Place["76"]] = 1
hash[Place["７６"]]             # => 1

[1, 2].hash                     # => -3783185017154092323
[1, 2].hash                     # => -3783185017154092323

Place["13"].opponent_side?(:black) # => true
Place["14"].opponent_side?(:black) # => false
Place["16"].opponent_side?(:white) # => false
Place["17"].opponent_side?(:white) # => true
Place["13"].own_side?(:white) # => true
Place["14"].own_side?(:white) # => false
Place["16"].own_side?(:black) # => false
Place["17"].own_side?(:black) # => true
