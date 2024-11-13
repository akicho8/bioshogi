require "./setup"

container = Container::Basic.new

Dimension.change([2, 3]) do
  container = Container::Basic.new
  container.placement_from_bod <<~EOT
  +------+
  | ・v玉|
  | ・v角|
  | 玉 香|
  +------+
  手数＝1
EOT
  container.current_player.move_hands(promoted_only: true).collect(&:to_s) # => ["△２二玉(11)", "△２一玉(11)", "△２三角成(12)", "△２一角成(12)"]
end

container = Container::Basic.new
container.board.placement_from_shape(<<~EOT)
+---------+
| ・v銀 ・|
| ・ ○ ・|
|v銀 ・ ・|
+---------+
EOT
container.next_player.execute("22銀上")
# "２二銀上" が正しい
container.hand_logs.last.to_ki2 # => "２二銀上"
