require "./example_helper"

Parser::Ki2Parser.accept?("▲2六歩") # => 
Parser::Ki2Parser.parse("▲2六歩") # => 

puts Parser.parse("▲2六歩").to_kif
puts Parser.parse("▲2六歩").to_ki2

info = Parser.parse(<<~EOT)
▲2六歩 ▽3四歩 ▲2五歩 ▽3三角 ▲7六歩
▽4二銀 ▲4八銀 ▽5四歩 ▲6八玉 ▽5五歩
EOT
puts info.to_ki2






# ~> -:1:in `require_relative': cannot infer basepath (LoadError)
# ~> 	from -:1:in `<main>'
