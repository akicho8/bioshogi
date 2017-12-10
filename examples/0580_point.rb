require "./example_helper"

Point["１一"].to_xy             # => [8, 0]
Point["１一"] == Point["１一"]  # => true

a = Point["１一"]
b = Point["２一"]
[a, b]                          # => [#<Bushido::Point:70357212629480 "１一">, #<Bushido::Point:70357212629100 "２一">]
[a, b].sort rescue $!           # => [#<Bushido::Point:70357212629100 "２一">, #<Bushido::Point:70357212629480 "１一">]
[a, b].sort_by(&:to_xy)         # => [#<Bushido::Point:70357212629100 "２一">, #<Bushido::Point:70357212629480 "１一">]

Point["１一"].object_id         # => 70357212616140
Point["11"].object_id           # => 70357212614920

# Position::Hpos.parse(1).object_id # => 70357212614280
# Position::Hpos.parse(1).object_id # => 70357212614280
