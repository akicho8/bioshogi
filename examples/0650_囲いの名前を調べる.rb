require "./example_helper"

mediator = Mediator.new
mediator.board_reset_by_shape(<<~EOT)
+---------------------------+
|v香 ・ ・ ・ ・v銀 ・ ・ ・|
| ・ ・ ・v金v金v玉 ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ 歩 歩 歩 ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ 金 銀 金 ・ ・ ・ ・|
| 香 ・ ・ 玉 ・ ・ ・ ・ ・|
+---------------------------+
  EOT

location = Location[:black]

soldiers = mediator.board.surface.values.find_all {|e|e.location == location }
tp soldiers.collect(&:name)
sorted_black_side_mini_soldiers = soldiers.collect{|e|e.to_mini_soldier.as_black_side}.sort
tp sorted_black_side_mini_soldiers

defense_info = DefenseInfo.find do |e|
  # p e.name

  # 盤上の状態に含まれる？
  e.black_side_mini_soldiers.all? do |e|
    if soldier = mediator.board[e[:point]]
      if soldier.location == location
        soldier.to_mini_soldier.as_black_side == e
      end
    end
  end

  # # 盤上と完全一致
  # e.sorted_black_side_mini_soldiers == sorted_black_side_mini_soldiers
end
p defense_info&.name
# >> |----------|
# >> | ▲７六歩 |
# >> | ▲６六歩 |
# >> | ▲５六歩 |
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
# >> | 歩    | false    | ６六  | ▲       |
# >> | 銀    | false    | ６八  | ▲       |
# >> | 玉    | false    | ６九  | ▲       |
# >> | 歩    | false    | ５六  | ▲       |
# >> | 金    | false    | ５八  | ▲       |
# >> |-------+----------+-------+----------|
# >> "カニ囲い"
