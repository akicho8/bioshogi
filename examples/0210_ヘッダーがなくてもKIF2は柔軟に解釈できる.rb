require "./example_helper"

Parser::Ki2Parser.accept?("▲２六歩") # => 
Parser::Ki2Parser.parse("▲２六歩") # => 

puts Parser.parse("▲２六歩").to_kif
puts Parser.parse("▲２六歩").to_ki2

info = Parser.parse(<<~EOT)
▲２六歩 ▽３四歩 ▲２五歩 ▽３三角 ▲７六歩
▽４二銀 ▲４八銀 ▽５四歩 ▲６八玉 ▽５五歩
EOT
puts info.to_ki2






# ~> -:1:in `require_relative': cannot infer basepath (LoadError)
# ~> 	from -:1:in `<main>'
