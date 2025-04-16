require "./setup"

tp Analysis::AttackInfo["相横歩取り"].board_parser.other_objects_loc_ary

# tp Analysis::TacticInfo.all_soldier_places_hash1.inject({}) {|a, (k, v)| a.merge(k.name => v.count) }
# tp Analysis::TacticInfo.all_soldier_places_hash2.inject({}) {|a, (k, v)| a.merge(k.name => v.count) }
tp Analysis::TacticInfo.primary_soldiers.inject({}) { |a, (k, v)| a.merge(k.name => v.count) }

tp Analysis::TacticInfo.all_soldier_places_hash.inject({}) { |a, (k, v)| a.merge(k.name => v.count) }

# ~> -:7:in `<main>': undefined method `primary_soldiers' for Bioshogi::TacticInfo:Class (NoMethodError)
# >> |-------+------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> | black | {"○"=>[{:place=>#<Bioshogi::Place ３三>, :prefix_char=>" ", :something=>"○"}, {:place=>#<Bioshogi::Place ７七>, :prefix_char=>" ", :something=>"○"}]} |
# >> | white | {"○"=>[{:place=>#<Bioshogi::Place ７七>, :prefix_char=>" ", :something=>"○"}, {:place=>#<Bioshogi::Place ３三>, :prefix_char=>" ", :something=>"○"}]} |
# >> |-------+------------------------------------------------------------------------------------------------------------------------------------------------------|
