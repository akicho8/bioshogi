require "./example_helper"

teai_info = TeaiInfo["平手"].both_board_info[Location[:black]]

mediator = Mediator.start
mediator.board_reset
mini_soldiers = mediator.board.surface.values.collect {|e|
  if e.player.location.key == :black
    e.to_mini_soldier
  end
}.compact

mini_soldiers.sort.collect(&:name) # => ["９七歩", "９九香", "８七歩", "８八角", "８九桂", "７七歩", "７九銀", "６七歩", "６九金", "５七歩", "５九玉", "４七歩", "４九金", "３七歩", "３九銀", "２七歩", "２八飛", "２九桂", "１七歩", "１九香"]
teai_info.sort.collect(&:name)     # => ["９七歩", "９九香", "８七歩", "８八角", "８九桂", "７七歩", "７九銀", "６七歩", "６九金", "５七歩", "５九玉", "４七歩", "４九金", "３七歩", "３九銀", "２七歩", "２八飛", "２九桂", "１七歩", "１九香"]

mini_soldiers.sort == teai_info.sort # => false

mini_soldiers.sort.first        # => {:piece=><Bushido::Piece:70168203774880 歩 pawn>, :promoted=>false, :point=>#<Bushido::Point:70168202530940 "９七">}
teai_info.sort.first            # => {:piece=><Bushido::Piece:70168203774880 歩 pawn>, :promoted=>false, :point=>#<Bushido::Point:70168202530940 "９七">, :location=>#<Bushido::Location:0x007fa29dbcb758 @attributes={:key=>:black, :name=>"先手", :mark=>"▲", :reverse_mark=>"▼", :other_marks=>["上手", "☗", "b"], :varrow=>" ", :angle=>0, :csa_sign=>"+", :code=>0}, @match_target_values_set=#<Set: {:black, "▲", "▼", "上手", "☗", "b", "先手", "先", 0, " ", "+"}>>}

#         # ここがかなり重い
#         StaticBoardInfo.collect do |static_board_info|
#           placements = Utils.board_point_realize(location: location, both_board_info: static_board_info.both_board_info)
#           a = placements.values.flatten.collect(&:to_s)
#           b = board.surface.values.collect(&:to_h).collect(&:to_s)
#           match_p = (a - b).empty?
#           {key: static_board_info.key, placements: placements, match: match_p}
#         end
