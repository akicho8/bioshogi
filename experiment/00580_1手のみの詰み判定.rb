require "./setup"

Board.dimensiton_change([2, 3]) do
  xcontainer = Xcontainer.new
  xcontainer.placement_from_bod <<~EOT
  後手の持駒：
  +------+
  | ・v玉|
  | ・ 金|
  | ・ 金|
  +------+
  先手の持駒：
  手数＝1
  EOT
  xcontainer.player_at(:black).my_mate? # => false
  xcontainer.player_at(:black).op_mate? # => true
  xcontainer.player_at(:white).my_mate? # => true
  xcontainer.player_at(:white).op_mate? # => false
end
