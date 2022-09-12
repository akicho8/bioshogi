require "./setup"

# Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

Board.dimensiton_change([2, 5])
xcontainer = Xcontainer.new
xcontainer.board.placement_from_shape <<~EOT
+------+
|v飛 ・|
| ・ ・|
| ・ ・|
| ・ 飛|
+------+
  EOT

1000.times do
  puts "-" * 80
  puts xcontainer

  info = xcontainer.current_player.brain.diver_dive(depth_max: 1)
  p info
  hand = info[:hand]
  puts "指し手: #{hand}"
  tp xcontainer.one_place_map
  xcontainer.execute(hand.to_sfen, executor_class: PlayerExecutorWithoutMonitor)
end

# xcontainer.execute("▲17飛", executor_class: PlayerExecutorWithoutMonitor)
# xcontainer.execute("△23飛", executor_class: PlayerExecutorWithoutMonitor)
# xcontainer.execute("▲19飛", executor_class: PlayerExecutorWithoutMonitor)
# xcontainer.execute("△21飛", executor_class: PlayerExecutorWithoutMonitor)
#
# # xcontainer.execute("▲１七飛", executor_class: PlayerExecutorWithoutMonitor)
# # tp xcontainer.one_place_map
# # xcontainer.player_at(:black).evaluator.score  # => 0
# # xcontainer.player_at(:black).evaluator.score2 # => 0
#
# xcontainer.player_at(:black).brain.diver_dive(depth_max: 1) # => {:hand=>#<▲２八香(29)>, :score=>0, :depth=>0, :reading_hands=>[#<▲２八香(29)>, #<△９一飛(21)>]}
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
