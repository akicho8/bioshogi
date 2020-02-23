require "./example_helper"

Board.dimensiton_change([2, 3]) do
  mediator = Mediator.new
  mediator.placement_from_bod <<~EOT
  後手の持駒：
  +------+
  | ・v玉|
  | ・v角|
  | 玉 香|
  +------+
    先手の持駒：
  手数＝1
  EOT
  mediator.current_player.move_hands(with_no_promoted: true).collect(&:to_s)                           # => ["△２二玉(11)", "△２一玉(11)", "△２三角成(12)", "△２一角成(12)"]
  mediator.current_player.move_hands(with_no_promoted: true).collect(&:to_s)                           # => ["△２二玉(11)", "△２一玉(11)", "△２三角成(12)", "△２一角成(12)"]
  mediator.current_player.move_hands.collect(&:to_s)                                                # => ["△２二玉(11)", "△２一玉(11)", "△２三角成(12)", "△２三角(12)", "△２一角成(12)", "△２一角(12)"]
  mediator.current_player.move_hands(with_no_promoted: true, king_captured_only: true).collect(&:to_s) # => ["△２三角成(12)"]
  mediator.current_player.legal_all_hands.collect(&:to_s)                                           # => ["△２一玉(11)"]
  mediator.current_player.mate_danger?                                                              # => false
  mediator.current_player.mate_advantage?                                                           # => true
  mediator.current_player.king_capture_move_hands.collect(&:to_s)                                   # => ["△２三角成(12)"]
  mediator.current_player.move_hands(mate_only: true).collect(&:to_s)                               # => ["△２二玉(11)", "△２一玉(11)"]
end
