require "./example_helper"

Place["１一"].to_xy             # => [8, 0]
Place["１一"] == Place["１一"]  # => true

a = Place["１一"]
b = Place["２一"]
[a, b]                          # => [#<Warabi::Place:70134107452380 "１一">, #<Warabi::Place:70134107433460 "２一">]
[a, b].sort rescue $!           # => [#<Warabi::Place:70134107433460 "２一">, #<Warabi::Place:70134107452380 "１一">]
[a, b].sort_by(&:to_xy)         # => [#<Warabi::Place:70134107433460 "２一">, #<Warabi::Place:70134107452380 "１一">]

Place["１一"].object_id         # => 70134107371840
Place["11"].object_id           # => 70134107352560

# OnePlace::Yplace.fetch(1).object_id # => 70357212614280
# OnePlace::Yplace.fetch(1).object_id # => 70357212614280

Place["76"].hash                # => 3101916364998623432
Place["７６"].hash              # => 3101916364998623432
Place["76"].object_id           # => 70134107278440
Place["７６"].object_id         # => 70134107276040
hash = {}

hash[Place["76"]] = 1
hash[Place["７６"]]             # => 1

[1, 2].hash                     # => -1937462549542132907
[1, 2].hash                     # => -1937462549542132907
