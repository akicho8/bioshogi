require "./example_helper"

Point["１一"].to_xy             # => [8, 0]
Point["１一"] == Point["１一"]  # => true

a = Point["１一"]
b = Point["２一"]
[a, b]                          # => [#<Warabi::Point:70134107452380 "１一">, #<Warabi::Point:70134107433460 "２一">]
[a, b].sort rescue $!           # => [#<Warabi::Point:70134107433460 "２一">, #<Warabi::Point:70134107452380 "１一">]
[a, b].sort_by(&:to_xy)         # => [#<Warabi::Point:70134107433460 "２一">, #<Warabi::Point:70134107452380 "１一">]

Point["１一"].object_id         # => 70134107371840
Point["11"].object_id           # => 70134107352560

# Position::Hpos.fetch(1).object_id # => 70357212614280
# Position::Hpos.fetch(1).object_id # => 70357212614280

Point["76"].hash                # => 3101916364998623432
Point["７６"].hash              # => 3101916364998623432
Point["76"].object_id           # => 70134107278440
Point["７６"].object_id         # => 70134107276040
hash = {}

hash[Point["76"]] = 1
hash[Point["７６"]]             # => 1

[1, 2].hash                     # => -1937462549542132907
[1, 2].hash                     # => -1937462549542132907
