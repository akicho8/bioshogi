require "./example_helper"

Parser::Ki2Parser.resolved?("▲2六歩") # => true
Parser::Ki2Parser.parse("▲2六歩") # => #<Bushido::Parser::Ki2Parser:0x007fb3732a8ba8 @source="▲2六歩", @options={}, @header={}, @move_infos=[{:location=>#<Bushido::Location:0x007fb373271270 @attributes={:key=>:black, :name=>"先手", :mark=>"▲", :reverse_mark=>"▼", :other_marks=>["b", "^"], :varrow=>" ", :angle=>0, :code=>0}>, :input=>"2六歩", :mov=>"▲2六歩"}], @first_comments=[], @normalized_source="▲2六歩", @_head="", @_body="▲2六歩">

puts Parser.parse("▲2六歩").to_kif
puts Parser.parse("▲2六歩").to_ki2

info = Parser.parse(<<~EOT)
▲2六歩 ▽3四歩 ▲2五歩 ▽3三角 ▲7六歩
▽4二銀 ▲4八銀 ▽5四歩 ▲6八玉 ▽5五歩
EOT
puts info.to_ki2

# >> 手数----指手---------消費時間--
# >> 1 ▲2六歩(27) (00:00/00:00:00)
# >> 2 投了
# >> ▲2六歩
# >> まで1手で先手の勝ち
# >> ▲2六歩 ▽3四歩 ▲2五歩 ▽3三角 ▲7六歩 ▽4二銀 ▲4八銀 ▽5四歩 ▲6八玉 ▽5五歩
# >> まで10手で後手の勝ち
