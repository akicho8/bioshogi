require "./example_helper"

# info = Parser.file_parse("bouzu_mino.ki2")
# puts info.to_ki2

# a = [1, 2, 3, 4] - [2, 3]
#
# [1, 2, 3, 4] & [2, 3]           # => [2, 3]
#
# a                               # => [1, 4]
# exit
# exit

a = DefenseInfo["美濃囲い"].sorted_soldiers
b = DefenseInfo["片美濃囲い"].sorted_soldiers
a.collect(&:name)               # => ["５八金", "４九金", "３八銀", "２七歩", "２八玉"]
b.collect(&:name)               # => ["４九金", "３八銀", "２七歩", "２八玉"]

x = a.last # => {:piece=><Bushido::Piece:70365316155220 玉 king>, :promoted=>false, :point=>#<Bushido::Point:70365315618700 "２八">, :location=>#<Bushido::Location:0x007ffe675d0490 @attributes={:key=>:black, :name=>"▲", :hirate_name=>"先手", :komaochi_name=>"下手", :reverse_mark=>"▼", :varrow=>" ", :csa_sign=>"+", :angle=>0, :other_match_chars=>["☗", "b"], :code=>0}, @match_target_values_set=#<Set: {:black, "▲", "▼", "☗", "b", 0, " ", "+", "先手", "下手"}>>}
y = b.last # => {:piece=><Bushido::Piece:70365316155220 玉 king>, :promoted=>false, :point=>#<Bushido::Point:70365315568240 "２八">, :location=>#<Bushido::Location:0x007ffe675d0490 @attributes={:key=>:black, :name=>"▲", :hirate_name=>"先手", :komaochi_name=>"下手", :reverse_mark=>"▼", :varrow=>" ", :csa_sign=>"+", :angle=>0, :other_match_chars=>["☗", "b"], :code=>0}, @match_target_values_set=#<Set: {:black, "▲", "▼", "☗", "b", 0, " ", "+", "先手", "下手"}>>}

# c = a - b
# c.collect(&:name)               # => ["５八金", "４九金", "３八銀", "２七歩", "２八玉"]


# DefenseInfo.each do |e|
#   list = DefenseInfo.to_a - []
#   list = list.find_all { |o| (o.sorted_soldiers & e.sorted_soldiers) == e.sorted_soldiers }
#   if list.size >= 1
#     p [e.name, list.collect(&:name)]
#   end
# end
