require "#{__dir__}/setup"

Dimension::Column.char_infos # => ["９", "８", "７", "６", "５", "４", "３", "２", "１"]
Dimension::Column.units_set # => {"９"=>0, "８"=>1, "７"=>2, "６"=>3, "５"=>4, "４"=>5, "３"=>6, "２"=>7, "１"=>8}

Dimension::Column.fetch("9")  # => #<Bioshogi::Dimension::Column:70093708683760 "９" 0>
Dimension::Column.fetch("９") # => #<Bioshogi::Dimension::Column:70093708683760 "９" 0>
Dimension::Column.fetch("九") # => #<Bioshogi::Dimension::Column:70093708683760 "９" 0>

Dimension::Row.fetch("9")  # => #<Bioshogi::Dimension::Row:70093707713700 "九" 8>
Dimension::Row.fetch("９") # => #<Bioshogi::Dimension::Row:70093707713700 "九" 8>
Dimension::Row.fetch("九") # => #<Bioshogi::Dimension::Row:70093707713700 "九" 8>

Dimension.change([2, 4]) do
  Dimension::Column.char_infos # => ["２", "１"]
  Dimension::Column.units_set # => {"２"=>0, "１"=>1}
  Dimension::Column.units_set  # => {"２"=>0, "１"=>1}
  puts Board.new
  Place["22"].to_xy         # => [0, 1]
  Place["22"].name          # => "２二"
  Place["22"].flip.name  # => "１三"
  Dimension::Column.fetch("2") # => #<Bioshogi::Dimension::Column:70093707690420 "２" 0>
end

Dimension.change([1, 1]) do
  Dimension::Column.char_infos # => ["１"]
  Dimension::Column.units_set # => {"１"=>0}
  puts Board.new
  Place["11"].to_xy             # => [0, 0]
  Place["11"].name              # => "１一"
  Place["11"].flip.name  # => "１一"
  Dimension::Column.fetch("1") # => #<Bioshogi::Dimension::Column:70093712152580 "１" 0>
end

Dimension::Column.class_eval { @units_set } # => nil

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
