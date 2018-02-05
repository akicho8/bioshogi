require "./example_helper"

Point["１一"].to_xy             # => [8, 0]
Point["１一"] == Point["１一"]  # => true

a = Point["１一"]
b = Point["２一"]
[a, b]                          # => [#<Warabi::Point:70130724172720 "１一">, #<Warabi::Point:70130724171840 "２一">]
[a, b].sort rescue $!           # => [#<Warabi::Point:70130724171840 "２一">, #<Warabi::Point:70130724172720 "１一">]
[a, b].sort_by(&:to_xy)         # => [#<Warabi::Point:70130724171840 "２一">, #<Warabi::Point:70130724172720 "１一">]

Point["１一"].object_id         # => 70130724140620
Point["11"].object_id           # => 70130724138640

# Position::Hpos.fetch(1).object_id # => 70357212614280
# Position::Hpos.fetch(1).object_id # => 70357212614280

Point["76"].hash                # => -18060818701447600
Point["７６"].hash              # => -18060818701447600
Point["76"].object_id           # => 70130724122020
Point["７６"].object_id         # => 70130724119940
hash = {}

hash[Point["76"]] = 1
hash[Point["７６"]]             # => 1

[1, 2].hash                     # => -1617222415939986352
[1, 2].hash                     # => -1617222415939986352
