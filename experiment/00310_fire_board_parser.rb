require "./example_helper"

board_parser = BoardParser::FireBoardParser.parse(<<~EOT)
+------------+
| ・ ・ ★v香|
|!歩@歩?歩*歩|
+------------+
EOT

board_parser.soldiers                      # => [<Bioshogi::Soldier "△１一香">, <Bioshogi::Soldier "▲３二歩">]
board_parser.trigger_soldiers              # => [<Bioshogi::Soldier "▲４二歩">, <Bioshogi::Soldier "▲３二歩">]
board_parser.other_objects_hash_ary        # => {"★"=>[{:place=>#<Bioshogi::Place ２一>, :prefix_char=>" ", :something=>"★"}]}
board_parser.other_objects_hash            # => {"★"=>{#<Bioshogi::Place ２一>=>{:place=>#<Bioshogi::Place ２一>, :prefix_char=>" ", :something=>"★"}}}
board_parser.any_exist_soldiers            # => [<Bioshogi::Soldier "△２二歩">, <Bioshogi::Soldier "▲１二歩">]
board_parser.other_objects_loc_places_hash # => {:black=>{"★"=>{#<Bioshogi::Place ２一>=>{:place=>#<Bioshogi::Place ２一>, :prefix_char=>" ", :something=>"★"}}}, :white=>{"★"=>{#<Bioshogi::Place ８九>=>{:place=>#<Bioshogi::Place ８九>, :prefix_char=>" ", :something=>"★"}}}}
board_parser.any_exist_soldiers            # => [<Bioshogi::Soldier "△２二歩">, <Bioshogi::Soldier "▲１二歩">]
board_parser.primary_soldiers              # => [<Bioshogi::Soldier "▲４二歩">, <Bioshogi::Soldier "▲３二歩">]
