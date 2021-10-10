require "./setup"

Dimension::Xplace.units # => ["９", "８", "７", "６", "５", "４", "３", "２", "１"]
Dimension::Xplace.units_set # => {"９"=>0, "８"=>1, "７"=>2, "６"=>3, "５"=>4, "４"=>5, "３"=>6, "２"=>7, "１"=>8}

Dimension::Xplace.fetch("9")  # => #<Bioshogi::Dimension::Xplace:70093708683760 "９" 0>
Dimension::Xplace.fetch("９") # => #<Bioshogi::Dimension::Xplace:70093708683760 "９" 0>
Dimension::Xplace.fetch("九") # => #<Bioshogi::Dimension::Xplace:70093708683760 "９" 0>

Dimension::Yplace.fetch("9")  # => #<Bioshogi::Dimension::Yplace:70093707713700 "九" 8>
Dimension::Yplace.fetch("９") # => #<Bioshogi::Dimension::Yplace:70093707713700 "九" 8>
Dimension::Yplace.fetch("九") # => #<Bioshogi::Dimension::Yplace:70093707713700 "九" 8>

Board.dimensiton_change([2, 4]) do
  Dimension::Xplace.units # => ["２", "１"]
  Dimension::Xplace.units_set # => {"２"=>0, "１"=>1}
  Dimension::Xplace.units_set  # => {"２"=>0, "１"=>1}
  puts Board.new
  Place["22"].to_xy         # => [0, 1]
  Place["22"].name          # => "２二"
  Place["22"].flip.name  # => "１三"
  Dimension::Xplace.fetch("2") # => #<Bioshogi::Dimension::Xplace:70093707690420 "２" 0>
end

Board.dimensiton_change([1, 1]) do
  Dimension::Xplace.units # => ["１"]
  Dimension::Xplace.units_set # => {"１"=>0}
  puts Board.new
  Place["11"].to_xy             # => [0, 0]
  Place["11"].name              # => "１一"
  Place["11"].flip.name  # => "１一"
  Dimension::Xplace.fetch("1") # => #<Bioshogi::Dimension::Xplace:70093712152580 "１" 0>
end

Dimension::Xplace.class_eval { @units_set } # => nil

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
