require "./example_helper"

teai_info = TeaiInfo["平手"].both_board_info[L.b]

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

mini_soldiers.sort.first        # => {:point=>#<Bushido::Point:70170924237440 "９七">, :piece=><Bushido::Piece:70170922755640 歩 pawn>, :promoted=>false}
teai_info.sort.first            # => {:piece=><Bushido::Piece:70170922755640 歩 pawn>, :point=>#<Bushido::Point:70170924237440 "９七">}

#         # ここがかなり重い
#         StaticBoardInfo.collect do |static_board_info|
#           placements = Utils.point_normalize_if_white(location: location, both_board_info: static_board_info.both_board_info)
#           a = placements.values.flatten.collect(&:to_s)
#           b = board.surface.values.collect(&:to_h).collect(&:to_s)
#           match_p = (a - b).empty?
#           {key: static_board_info.key, placements: placements, match: match_p}
#         end
