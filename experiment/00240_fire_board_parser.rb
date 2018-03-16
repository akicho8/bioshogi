require "./example_helper"

board_parser = BoardParser::FireBoardParser.parse(<<~EOT)
+------------+
| ・ ・ ★v香|
|!歩@歩?歩*歩|
+------------+
EOT

board_parser.soldiers                      # => [<Warabi::Soldier "△１一香">, <Warabi::Soldier "▲３二歩">]
board_parser.trigger_soldiers              # => [<Warabi::Soldier "▲４二歩">, <Warabi::Soldier "▲３二歩">]
board_parser.other_objects_hash_ary        # => {"★"=>[{:place=>#<Warabi::Place ２一>, :prefix_char=>" ", :something=>"★"}]}
board_parser.other_objects_hash            # => {"★"=>{#<Warabi::Place ２一>=>{:place=>#<Warabi::Place ２一>, :prefix_char=>" ", :something=>"★"}}}
board_parser.any_exist_soldiers            # => [<Warabi::Soldier "△２二歩">, <Warabi::Soldier "▲１二歩">]
board_parser.other_objects_loc_places_hash # => {:black=>{"★"=>{#<Warabi::Place ２一>=>{:place=>#<Warabi::Place ２一>, :prefix_char=>" ", :something=>"★"}}}, :white=>{"★"=>{#<Warabi::Place ８九>=>{:place=>#<Warabi::Place ８九>, :prefix_char=>" ", :something=>"★"}}}}
board_parser.any_exist_soldiers            # => [<Warabi::Soldier "△２二歩">, <Warabi::Soldier "▲１二歩">]
board_parser.primary_soldiers              # => [<Warabi::Soldier "▲４二歩">, <Warabi::Soldier "▲３二歩">]

