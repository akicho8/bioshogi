require "./example_helper"

Place["１一"].to_xy             # => [8, 0]
Place["１一"] == Place["１一"]  # => true

a = Place["１一"]
b = Place["２一"]
[a, b]                          # => [#<Warabi::Place １一>, #<Warabi::Place ２一>]
[a, b].sort rescue $!           # => [#<Warabi::Place ２一>, #<Warabi::Place １一>]
[a, b].sort_by(&:to_xy)         # => [#<Warabi::Place ２一>, #<Warabi::Place １一>]

Place["１一"].object_id         # => 70358313581400
Place["11"].object_id           # => 70358313581400

# Dimension::Yplace.fetch(1).object_id # => 70357212614280
# Dimension::Yplace.fetch(1).object_id # => 70357212614280

Place["76"].hash                # => 4403409874737129796
Place["７６"].hash              # => 4403409874737129796
Place["76"].object_id           # => 70358313566020
Place["７６"].object_id         # => 70358313566020
hash = {}

hash[Place["76"]] = 1
hash[Place["７６"]]             # => 1

[1, 2].hash                     # => 2401496476098925425
[1, 2].hash                     # => 2401496476098925425
