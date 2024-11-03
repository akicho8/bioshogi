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

Place["76"].hash                # => 2060813857063383936
Place["７６"].hash              # => 2060813857063383936
Place["76"].object_id           # => 2060
Place["７６"].object_id         # => 2060
hash = {}

hash[Place["76"]] = 1
hash[Place["７６"]]             # => 1

[1, 2].hash                     # => 3958640546780934600
[1, 2].hash                     # => 3958640546780934600

Place["13"].opponent_side?(:black) # => true
Place["14"].opponent_side?(:black) # => false
Place["16"].opponent_side?(:white) # => false
Place["17"].opponent_side?(:white) # => true
Place["13"].own_side?(:white) # => true
Place["14"].own_side?(:white) # => false
Place["16"].own_side?(:black) # => false
Place["17"].own_side?(:black) # => true

require "./setup"

Dimension::PlaceX.char_infos # => [<9>, <8>, <7>, <6>, <5>, <4>, <3>, <2>, <1>]

Dimension::PlaceX.fetch("9")  # => #<Bioshogi::Dimension::PlaceX:2080 "９" 0>
Dimension::PlaceX.fetch("９") # => #<Bioshogi::Dimension::PlaceX:2080 "９" 0>
Dimension::PlaceX.fetch("九") # => #<Bioshogi::Dimension::PlaceX:2080 "９" 0>

Dimension::PlaceY.fetch("9")  # => #<Bioshogi::Dimension::PlaceY:2100 "九" 8>
Dimension::PlaceY.fetch("９") # => #<Bioshogi::Dimension::PlaceY:2100 "九" 8>
Dimension::PlaceY.fetch("九") # => #<Bioshogi::Dimension::PlaceY:2100 "九" 8>

# Dimension.wh_change([2, 4]) do
Dimension::PlaceX.char_infos # => [<9>, <8>, <7>, <6>, <5>, <4>, <3>, <2>, <1>]
puts Board.new
Place["22"].to_xy         # => [7, 1]
Place["22"].name          # => "２二"
Place["22"].flip.name  # => "８八"
Dimension::PlaceX.fetch("2") # => #<Bioshogi::Dimension::PlaceX:2120 "２" 7>

Dimension::PlaceX.char_infos # => [<9>, <8>, <7>, <6>, <5>, <4>, <3>, <2>, <1>]
puts Board.new
Place["11"].to_xy             # => [8, 0]
Place["11"].name              # => "１一"
Place["11"].flip.name  # => "９九"
Dimension::PlaceX.fetch("1") # => #<Bioshogi::Dimension::PlaceX:2140 "１" 8>

puts Board.new

# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|一
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|二
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# >> +---------------------------+
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|一
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|二
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# >> +---------------------------+
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|一
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|二
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# >> +---------------------------+
