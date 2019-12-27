require "./example_helper"

# Bioshogi.logger = ActiveSupport::Logger.new(STDOUT)

Board.dimensiton_change([2, 5])
mediator = Mediator.new
mediator.board.placement_from_shape <<~EOT
+------+
|v飛 ・|
| ・ ・|
| ・ ・|
| ・ 飛|
+------+
  EOT

1000.times do
  puts "-" * 80
  puts mediator

  info = mediator.current_player.brain.diver_dive(depth_max: 1)
  p info
  hand = info[:hand]
  puts "指し手: #{hand}"
  tp mediator.one_place_map
  mediator.execute(hand.to_sfen, executor_class: PlayerExecutorCpu)
end

# mediator.execute("▲17飛", executor_class: PlayerExecutorCpu)
# mediator.execute("△23飛", executor_class: PlayerExecutorCpu)
# mediator.execute("▲19飛", executor_class: PlayerExecutorCpu)
# mediator.execute("△21飛", executor_class: PlayerExecutorCpu)
#
# # mediator.execute("▲１七飛", executor_class: PlayerExecutorCpu)
# # tp mediator.one_place_map
# # mediator.player_at(:black).evaluator.score  # => 0
# # mediator.player_at(:black).evaluator.score2 # => 0
#
# mediator.player_at(:black).brain.diver_dive(depth_max: 1) # => {:hand=>#<▲２八香(29)>, :score=>0, :depth=>0, :reading_hands=>[#<▲２八香(29)>, #<△９一飛(21)>]}
# ~> -:22:in `block in <main>': no implicit conversion of Symbol into Integer (TypeError)
# ~> 	from -:16:in `times'
# ~> 	from -:16:in `<main>'
# >> --------------------------------------------------------------------------------
# >> 後手の持駒：なし
# >>   ２ １
# >> +------+
# >> |v飛 ・|一
# >> | ・ ・|二
# >> | ・ ・|三
# >> | ・ 飛|四
# >> | ・ ・|五
# >> +------+
# >> 先手の持駒：なし
# >> 手数＝0 まで
# >> 
# >> 先手番
# >> [200, [<▲１三飛成(14)>]]
