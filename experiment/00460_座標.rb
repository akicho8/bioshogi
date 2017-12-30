require "./example_helper"

Position::Hpos.units # => ["９", "８", "７", "６", "５", "４", "３", "２", "１"]
Position::Hpos.units_set # => {"９"=>0, "８"=>1, "７"=>2, "６"=>3, "５"=>4, "４"=>5, "３"=>6, "２"=>7, "１"=>8}

Position::Hpos.fetch("9")  # => #<Bushido::Position::Hpos:70093708683760 "９" 0>
Position::Hpos.fetch("９") # => #<Bushido::Position::Hpos:70093708683760 "９" 0>
Position::Hpos.fetch("九") # => #<Bushido::Position::Hpos:70093708683760 "９" 0>

Position::Vpos.fetch("9")  # => #<Bushido::Position::Vpos:70093707713700 "九" 8>
Position::Vpos.fetch("９") # => #<Bushido::Position::Vpos:70093707713700 "九" 8>
Position::Vpos.fetch("九") # => #<Bushido::Position::Vpos:70093707713700 "九" 8>

Board.size_change([2, 4]) do
  Position::Hpos.units # => ["２", "１"]
  Position::Hpos.units_set # => {"２"=>0, "１"=>1}
  Position::Hpos.units_set  # => {"２"=>0, "１"=>1}
  puts Board.new
  Point["22"].to_xy         # => [0, 1]
  Point["22"].name          # => "２二"
  Point["22"].reverse.name  # => "１三"
  Position::Hpos.fetch("2") # => #<Bushido::Position::Hpos:70093707690420 "２" 0>
end

Board.size_change([1, 1]) do
  Position::Hpos.units # => ["１"]
  Position::Hpos.units_set # => {"１"=>0}
  puts Board.new
  Point["11"].to_xy             # => [0, 0]
  Point["11"].name              # => "１一"
  Point["11"].reverse.name  # => "１一"
  Position::Hpos.fetch("1") # => #<Bushido::Position::Hpos:70093712152580 "１" 0>
end

Position::Hpos.class_eval { @units_set } # => nil

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
