require "./setup"

Dimension.wh_change([2, 3]) do
  container = Container::Basic.new
  container.placement_from_bod <<~EOT
  後手の持駒：
  +------+
  | ・v玉|
  | ・ 金|
  | ・ 金|
  +------+
  先手の持駒：
  手数＝1
  EOT
  container.player_at(:black).my_mate? # => false
  container.player_at(:black).op_mate? # => true
  container.player_at(:white).my_mate? # => true
  container.player_at(:white).op_mate? # => false
end
