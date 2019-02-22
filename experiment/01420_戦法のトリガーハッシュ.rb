require "./example_helper"

tp AttackInfo["相横歩取り"].board_parser.other_objects_loc_ary

# tp TacticInfo.all_soldier_places_hash1.inject({}) {|a, (k, v)| a.merge(k.name => v.count) }
# tp TacticInfo.all_soldier_places_hash2.inject({}) {|a, (k, v)| a.merge(k.name => v.count) }
tp TacticInfo.primary_soldiers.inject({}) {|a, (k, v)| a.merge(k.name => v.count) }

tp TacticInfo.all_soldier_places_hash.inject({}) {|a, (k, v)| a.merge(k.name => v.count) }

# ~> -:7:in `<main>': undefined method `primary_soldiers' for Warabi::TacticInfo:Class (NoMethodError)
# >> |-------+------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> | black | {"○"=>[{:place=>#<Warabi::Place ３三>, :prefix_char=>" ", :something=>"○"}, {:place=>#<Warabi::Place ７七>, :prefix_char=>" ", :something=>"○"}]} |
# >> | white | {"○"=>[{:place=>#<Warabi::Place ７七>, :prefix_char=>" ", :something=>"○"}, {:place=>#<Warabi::Place ３三>, :prefix_char=>" ", :something=>"○"}]} |
# >> |-------+------------------------------------------------------------------------------------------------------------------------------------------------------|
