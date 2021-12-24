require "./setup"

Place["１一"].to_xy             # => [8, 0]
Place["１一"] == Place["１一"]  # => true

a = Place["１一"]
b = Place["２一"]
[a, b]                          # => [#<Bioshogi::Place １一>, #<Bioshogi::Place ２一>]
[a, b].sort rescue $!           # => [#<Bioshogi::Place ２一>, #<Bioshogi::Place １一>]
[a, b].sort_by(&:to_xy)         # => [#<Bioshogi::Place ２一>, #<Bioshogi::Place １一>]

Place["１一"].object_id         # => 70365784122760
Place["11"].object_id           # => 70365784122760

# Dimension::Xplace.fetch(1).object_id # => 70357212614280
# Dimension::Xplace.fetch(1).object_id # => 70357212614280

Place["76"].hash                # => 4054484507711954590
Place["７６"].hash              # => 4054484507711954590
Place["76"].object_id           # => 70365784132820
Place["７６"].object_id         # => 70365784132820
hash = {}

hash[Place["76"]] = 1
hash[Place["７６"]]             # => 1

[1, 2].hash                     # => -3555430358149038206
[1, 2].hash                     # => -3555430358149038206
