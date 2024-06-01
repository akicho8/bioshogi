require "./setup"

Parser::Ki2Parser.accept?("▲２六歩") # => true
Parser::Ki2Parser.parse("▲２六歩") # => #<Bioshogi::Parser::Ki2Parser:0x007fca908691f8 @source="▲２六歩", @options={}, @pi.header={}, @pi.move_infos=[{:location=>#<Bioshogi::Location:0x007fca8fb44590 @attributes={:key=>:black, :name=>"先手", :mark=>"▲", :flip_mark=>"▼", :other_match_chars=>["上手", "☗", "b"], :varrow=>" ", :angle=>0, :csa_sign=>"+", :code=>0}>, :input=>"２六歩", :mov=>"▲２六歩"}], @pi.first_comments=[], @pi.board_source=nil, @normalized_source="▲２六歩\n">

puts Parser.parse("▲２六歩").to_kif
puts Parser.parse("▲２六歩").to_ki2

info = Parser.parse(<<~EOT)
▲２六歩 ▽３四歩 ▲２五歩 ▽３三角 ▲７六歩
▽４二銀 ▲４八銀 ▽５四歩 ▲６八玉 ▽５五歩
EOT
puts info.to_ki2


