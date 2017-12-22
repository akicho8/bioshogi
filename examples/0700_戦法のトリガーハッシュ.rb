require "./example_helper"

tp AttackInfo["相横歩取り"].board_parser.other_objects_loc_ary

# tp TacticInfo.all_soldier_points_hash1.inject({}) {|a, (k, v)| a.merge(k.name => v.count) }
# tp TacticInfo.all_soldier_points_hash2.inject({}) {|a, (k, v)| a.merge(k.name => v.count) }
tp TacticInfo.primary_soldiers.inject({}) {|a, (k, v)| a.merge(k.name => v.count) }

tp TacticInfo.all_soldier_points_hash.inject({}) {|a, (k, v)| a.merge(k.name => v.count) }

# ~> -:7:in `<main>': undefined method `primary_soldiers' for Bushido::TacticInfo:Class (NoMethodError)
# >> |-------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> | black | {"○"=>[{:point=>#<Bushido::Point:70159022026820 "３三">, :prefix_char=>" ", :something=>"○"}, {:point=>#<Bushido::Point:70159021974720 "７七">, :prefix_char=>" ", :something=>"○"}]} |
# >> | white | {"○"=>[{:point=>#<Bushido::Point:70159021925280 "７七">, :prefix_char=>" ", :something=>"○"}, {:point=>#<Bushido::Point:70159021925140 "３三">, :prefix_char=>" ", :something=>"○"}]} |
# >> |-------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
