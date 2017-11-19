require "./example_helper"

Point["１一"].to_xy             # => [8, 0]
Point["１一"] == Point["１一"]  # => true

a = Point["１一"]
b = Point["２一"]
[a, b]                          # => [#<Bushido::Point:70202033777780 "１一">, #<Bushido::Point:70202033777320 "２一">]
[a, b].sort rescue $!           # => [#<Bushido::Point:70202033777320 "２一">, #<Bushido::Point:70202033777780 "１一">]
[a, b].sort_by(&:to_xy)         # => [#<Bushido::Point:70202033777320 "２一">, #<Bushido::Point:70202033777780 "１一">]
