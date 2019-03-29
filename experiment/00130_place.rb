require "./example_helper"

Place["１一"].to_xy             # => [8, 0]
Place["１一"] == Place["１一"]  # => true

a = Place["１一"]
b = Place["２一"]
[a, b]                          # => [#<Bioshogi::Place １一>, #<Bioshogi::Place ２一>]
[a, b].sort rescue $!           # => [#<Bioshogi::Place ２一>, #<Bioshogi::Place １一>]
[a, b].sort_by(&:to_xy)         # => [#<Bioshogi::Place ２一>, #<Bioshogi::Place １一>]

Place["１一"].object_id         # => 70320263722920
Place["11"].object_id           # => 70320263722920

# Dimension::Xplace.fetch(1).object_id # => 70357212614280
# Dimension::Xplace.fetch(1).object_id # => 70357212614280

Place["76"].hash                # => 424653379765652915
Place["７６"].hash              # => 424653379765652915
Place["76"].object_id           # => 70320263691020
Place["７６"].object_id         # => 70320263691020
hash = {}

hash[Place["76"]] = 1
hash[Place["７６"]]             # => 1

[1, 2].hash                     # => -3603605086070937867
[1, 2].hash                     # => -3603605086070937867
