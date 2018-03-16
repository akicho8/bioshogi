require "./example_helper"

OnePlace::Yplace.units # => ["９", "８", "７", "６", "５", "４", "３", "２", "１"]
OnePlace::Yplace.units_set # => {"９"=>0, "８"=>1, "７"=>2, "６"=>3, "５"=>4, "４"=>5, "３"=>6, "２"=>7, "１"=>8}

OnePlace::Yplace.fetch("9")  # => #<Warabi::OnePlace::Yplace:70093708683760 "９" 0>
OnePlace::Yplace.fetch("９") # => #<Warabi::OnePlace::Yplace:70093708683760 "９" 0>
OnePlace::Yplace.fetch("九") # => #<Warabi::OnePlace::Yplace:70093708683760 "９" 0>

OnePlace::Xplace.fetch("9")  # => #<Warabi::OnePlace::Xplace:70093707713700 "九" 8>
OnePlace::Xplace.fetch("９") # => #<Warabi::OnePlace::Xplace:70093707713700 "九" 8>
OnePlace::Xplace.fetch("九") # => #<Warabi::OnePlace::Xplace:70093707713700 "九" 8>

Board.dimensiton_change([2, 4]) do
  OnePlace::Yplace.units # => ["２", "１"]
  OnePlace::Yplace.units_set # => {"２"=>0, "１"=>1}
  OnePlace::Yplace.units_set  # => {"２"=>0, "１"=>1}
  puts Board.new
  Place["22"].to_xy         # => [0, 1]
  Place["22"].name          # => "２二"
  Place["22"].flip.name  # => "１三"
  OnePlace::Yplace.fetch("2") # => #<Warabi::OnePlace::Yplace:70093707690420 "２" 0>
end

Board.dimensiton_change([1, 1]) do
  OnePlace::Yplace.units # => ["１"]
  OnePlace::Yplace.units_set # => {"１"=>0}
  puts Board.new
  Place["11"].to_xy             # => [0, 0]
  Place["11"].name              # => "１一"
  Place["11"].flip.name  # => "１一"
  OnePlace::Yplace.fetch("1") # => #<Warabi::OnePlace::Yplace:70093712152580 "１" 0>
end

OnePlace::Yplace.class_eval { @units_set } # => nil

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
