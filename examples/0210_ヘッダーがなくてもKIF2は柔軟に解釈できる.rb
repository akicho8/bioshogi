require "./example_helper"

Parser::Ki2Parser.accept?("▲２六歩") # => true
Parser::Ki2Parser.parse("▲２六歩") # => #<Bushido::Parser::Ki2Parser:0x007fc33924ed30 @source="▲２六歩", @options={}, @header={}, @move_infos=[{:location=>#<Bushido::Location:0x007fc338b66fb8 @attributes={:key=>:black, :name=>"先手", :mark=>"▲", :reverse_mark=>"▼", :other_marks=>["b", "^"], :varrow=>" ", :angle=>0, :code=>0}>, :input=>"２六歩", :mov=>"▲２六歩"}], @first_comments=[], @normalized_source="▲２六歩">

puts Parser.parse("▲２六歩").to_kif
puts Parser.parse("▲２六歩").to_ki2

info = Parser.parse(<<~EOT)
▲２六歩 ▽３四歩 ▲２五歩 ▽３三角 ▲７六歩
▽４二銀 ▲４八銀 ▽５四歩 ▲６八玉 ▽５五歩
EOT
puts info.to_ki2

# >> 手数----指手---------消費時間--
# >>    1 ２六歩(27)   (00:00/00:00:00)
# >>    2 投了
# >> ▲２六歩
# >> まで1手で先手の勝ち
# >> ▲２六歩 ▽３四歩 ▲２五歩 ▽３三角 ▲７六歩 ▽４二銀 ▲４八銀 ▽５四歩 ▲６八玉 ▽５五歩
# >> まで10手で後手の勝ち
