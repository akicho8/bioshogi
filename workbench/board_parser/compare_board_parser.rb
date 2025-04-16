require "./setup"

board_parser = BoardParser::CompareBoardParser.parse(<<~EOT)
+------------+
|^銀~銀 ★v香|
|!歩@歩?歩*歩|
+------------+
EOT

board_parser.soldiers                      # => [<Bioshogi::Soldier "△１一香">, <Bioshogi::Soldier "▲３二歩">]
board_parser.trigger_soldiers              # => [<Bioshogi::Soldier "▲４二歩">, <Bioshogi::Soldier "▲３二歩">]
board_parser.other_objects_hash_ary        # => {"★"=>[{:place=>#<Bioshogi::Place ２一>, :prefix_char=>" ", :something=>"★"}]}
board_parser.other_objects_hash            # => {"★"=>{#<Bioshogi::Place ２一>=>{:place=>#<Bioshogi::Place ２一>, :prefix_char=>" ", :something=>"★"}}}
board_parser.black_any_exist_soldiers      # => [<Bioshogi::Soldier "▲１二歩">]
board_parser.white_any_exist_soldiers      # => [<Bioshogi::Soldier "△２二歩">]
board_parser.black_not_exist_soldiers      # => [<Bioshogi::Soldier "▲３一銀">]
board_parser.white_not_exist_soldiers      # => [<Bioshogi::Soldier "▲４一銀">]
board_parser.other_objects_loc_places_hash # => {:black=>{"★"=>{#<Bioshogi::Place ２一>=>{:place=>#<Bioshogi::Place ２一>, :prefix_char=>" ", :something=>"★"}}}, :white=>{"★"=>{#<Bioshogi::Place ８九>=>{:place=>#<Bioshogi::Place ８九>, :prefix_char=>" ", :something=>"★"}}}}
board_parser.primary_soldiers              # => [<Bioshogi::Soldier "▲４二歩">, <Bioshogi::Soldier "▲３二歩">]
