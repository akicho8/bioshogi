require "./example_helper"

# Board.logger = ActiveSupport::Logger.new(STDOUT)
# Board.promotable_disable
Board.dimensiton_change([3, 3])
mediator = Mediator.new
mediator.placement_from_bod <<~EOT
後手の持駒：
+---------+
|v玉 ・ ・|
| ・ 歩 歩|
|v飛 ・ 玉|
+---------+
先手の持駒：
手数＝0
EOT
mediator.current_player.normal_all_hands.to_a.collect(&:to_s) # => ["▲２一歩成(22)", "▲１一歩成(12)", "▲２三玉(13)"]
mediator.current_player.legal_all_hands.to_a.collect(&:to_s)  # => []

hand = mediator.current_player.normal_all_hands.first # => <▲２一歩成(22)>
hand.regal_move?(mediator)                            # => false
