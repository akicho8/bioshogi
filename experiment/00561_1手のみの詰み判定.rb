require "./example_helper"

Board.dimensiton_change([2, 3]) do
  mediator = Mediator.new
  mediator.placement_from_bod <<~EOT
  後手の持駒：
  +------+
  | ・v玉|
  | ・ 金|
  | ・ 金|
  +------+
  先手の持駒：
  手数＝1
  EOT
  mediator.player_at(:black).my_mate? # => false
  mediator.player_at(:black).op_mate? # => true
  mediator.player_at(:white).my_mate? # => true
  mediator.player_at(:white).op_mate? # => false
end
