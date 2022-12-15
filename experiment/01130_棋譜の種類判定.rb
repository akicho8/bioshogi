require "./setup"

klass = Parser.accepted_class(<<~EOT) # => Bioshogi::Parser::KifParser
1 ７六歩(77)   ( 0:34/00:00:34)
2 ３四歩(33)   ( 0:34/00:00:34)
EOT

klass = Parser.accepted_class(<<~EOT) # => Bioshogi::Parser::KifParser
1 ７六歩(77)
2 ３四歩(33)
EOT

klass = Parser.accepted_class(<<~EOT) # => Bioshogi::Parser::KifParser
1 ７六歩
2 ３四歩
EOT

klass = Parser.accepted_class(<<~EOT) # => Bioshogi::Parser::Ki2Parser
1７六歩
2３四歩
EOT

info = Parser.parse(<<~EOT)
1 投了
EOT
info.class.name                       # => "Bioshogi::Parser::KifParser"
info.mi.last_action_params               # => {:last_action_key=>"投了", :used_seconds=>nil}

info = Parser.parse(<<~EOT)
1 ７六歩
2 ３四歩
EOT
info.class.name                       # => "Bioshogi::Parser::KifParser"
info.mi.move_infos                       # => [{:turn_number=>"1", :input=>"７六歩", :clock_part=>nil, :used_seconds=>nil}, {:turn_number=>"2", :input=>"３四歩", :clock_part=>nil, :used_seconds=>nil}]

info = Parser.parse(<<~EOT)
1 ７六歩
2 ３四歩
EOT
info.class.name                       # => "Bioshogi::Parser::KifParser"
info.mi.move_infos                       # => [{:turn_number=>"1", :input=>"７六歩", :clock_part=>nil, :used_seconds=>nil}, {:turn_number=>"2", :input=>"３四歩", :clock_part=>nil, :used_seconds=>nil}]

info = Parser.parse(<<~EOT)
68銀
EOT
info.class.name                       # => "Bioshogi::Parser::Ki2Parser"
info.mi.move_infos                       # => [{:input=>"68銀"}]

info = Parser.parse(<<~EOT)
☗68銀
EOT
info.class.name                       # => "Bioshogi::Parser::Ki2Parser"
info.mi.move_infos                       # => [{:input=>"☗68銀"}]
