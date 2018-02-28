require "./example_helper"

board_parser = BoardParser::FireBoardParser.parse(<<~EOT)
+------------+
| ・ ・ ★v香|
|!歩@歩?歩*歩|
+------------+
EOT

board_parser.soldiers                      # => [<Warabi::Soldier "△１一香">, <Warabi::Soldier "▲３二歩">]
board_parser.trigger_soldiers              # => [<Warabi::Soldier "▲４二歩">, <Warabi::Soldier "▲３二歩">]
board_parser.other_objects_hash_ary        # => {"★"=>[{:point=>#<Warabi::Point ２一>, :prefix_char=>" ", :something=>"★"}]}
board_parser.other_objects_hash            # => {"★"=>{#<Warabi::Point ２一>=>{:point=>#<Warabi::Point ２一>, :prefix_char=>" ", :something=>"★"}}}
board_parser.any_exist_soldiers            # => [<Warabi::Soldier "△２二歩">, <Warabi::Soldier "▲１二歩">]
board_parser.other_objects_loc_points_hash # => {:black=>{"★"=>{#<Warabi::Point ２一>=>{:point=>#<Warabi::Point ２一>, :prefix_char=>" ", :something=>"★"}}}, :white=>{"★"=>{#<Warabi::Point ８九>=>{:point=>#<Warabi::Point ８九>, :prefix_char=>" ", :something=>"★"}}}}
board_parser.any_exist_soldiers            # => [<Warabi::Soldier "△２二歩">, <Warabi::Soldier "▲１二歩">]
board_parser.primary_soldiers              # => [<Warabi::Soldier "▲４二歩">, <Warabi::Soldier "▲３二歩">]

