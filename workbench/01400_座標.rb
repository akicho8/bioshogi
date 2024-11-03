require "./setup"

Dimension::PlaceX.char_infos # => ["９", "８", "７", "６", "５", "４", "３", "２", "１"]
Dimension::PlaceX.units_set # => {"９"=>0, "８"=>1, "７"=>2, "６"=>3, "５"=>4, "４"=>5, "３"=>6, "２"=>7, "１"=>8}

Dimension::PlaceX.fetch("9")  # => #<Bioshogi::Dimension::PlaceX:70093708683760 "９" 0>
Dimension::PlaceX.fetch("９") # => #<Bioshogi::Dimension::PlaceX:70093708683760 "９" 0>
Dimension::PlaceX.fetch("九") # => #<Bioshogi::Dimension::PlaceX:70093708683760 "９" 0>

Dimension::PlaceY.fetch("9")  # => #<Bioshogi::Dimension::PlaceY:70093707713700 "九" 8>
Dimension::PlaceY.fetch("９") # => #<Bioshogi::Dimension::PlaceY:70093707713700 "九" 8>
Dimension::PlaceY.fetch("九") # => #<Bioshogi::Dimension::PlaceY:70093707713700 "九" 8>

Dimension.wh_change([2, 4]) do
  Dimension::PlaceX.char_infos # => ["２", "１"]
  Dimension::PlaceX.units_set # => {"２"=>0, "１"=>1}
  Dimension::PlaceX.units_set  # => {"２"=>0, "１"=>1}
  puts Board.new
  Place["22"].to_xy         # => [0, 1]
  Place["22"].name          # => "２二"
  Place["22"].flip.name  # => "１三"
  Dimension::PlaceX.fetch("2") # => #<Bioshogi::Dimension::PlaceX:70093707690420 "２" 0>
end

Dimension.wh_change([1, 1]) do
  Dimension::PlaceX.char_infos # => ["１"]
  Dimension::PlaceX.units_set # => {"１"=>0}
  puts Board.new
  Place["11"].to_xy             # => [0, 0]
  Place["11"].name              # => "１一"
  Place["11"].flip.name  # => "１一"
  Dimension::PlaceX.fetch("1") # => #<Bioshogi::Dimension::PlaceX:70093712152580 "１" 0>
end

Dimension::PlaceX.class_eval { @units_set } # => nil

puts Board.new

# >>   ２ １
# >> +------+
# >> | ・ ・|一
# >> | ・ ・|二
# >> | ・ ・|三
# >> | ・ ・|四
# >> +------+
# >>   １
# >> +---+
# >> | ・|一
# >> +---+
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
