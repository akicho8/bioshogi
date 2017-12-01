require "./example_helper"

mediator = Mediator.new
mediator.board_reset_by_shape(<<~EOT)
+---------------------------+
|v香 ・ ・ ・ ・v銀 ・ ・ ・|
| ・ ・ ・v金v金v玉 ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ 歩 ・ 歩 ・ ・ ・ ・|
| ・ ・ ・ 歩 ・ ・ ・ ・ ・|
| ・ ・ 金 銀 金 ・ ・ ・ ・|
| 香 ・ ・ 玉 ・ ・ ・ ・ ・|
+---------------------------+
  EOT

location = Location[:black]

battlers = mediator.board.surface.values.find_all {|e|e.location == location }
tp battlers.collect(&:name)
sorted_black_side_soldiers = battlers.collect{|e|e.to_soldier.reverse_if_white}.sort
tp sorted_black_side_soldiers

defense_info = DefenseInfo.find do |e|
  # p e.name

  # 盤上の状態に含まれる？
  e.black_side_soldiers.all? do |e|
    if battler = mediator.board[e[:point]]
      if battler.location == location
        battler.to_soldier.reverse_if_white == e
      end
    end
  end

  # # 盤上と完全一致
  # e.sorted_black_side_soldiers == sorted_black_side_soldiers
end
tp defense_info
# >> |----------|
# >> | ▲７六歩 |
# >> | ▲５六歩 |
# >> | ▲６七歩 |
# >> | ▲７八金 |
# >> | ▲６八銀 |
# >> | ▲５八金 |
# >> | ▲９九香 |
# >> | ▲６九玉 |
# >> |----------|
# >> |-------+----------+-------+----------|
# >> | piece | promoted | point | location |
# >> |-------+----------+-------+----------|
# >> | 香    | false    | ９九  | ▲       |
# >> | 歩    | false    | ７六  | ▲       |
# >> | 金    | false    | ７八  | ▲       |
# >> | 歩    | false    | ６七  | ▲       |
# >> | 銀    | false    | ６八  | ▲       |
# >> | 玉    | false    | ６九  | ▲       |
# >> | 歩    | false    | ５六  | ▲       |
# >> | 金    | false    | ５八  | ▲       |
# >> |-------+----------+-------+----------|
# >> |----------|
# >> | カニ囲い |
# >> |----------|
