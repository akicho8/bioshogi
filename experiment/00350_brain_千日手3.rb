require "./example_helper"

# Warabi.logger = ActiveSupport::Logger.new(STDOUT)

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

  info = mediator.current_player.brain.nega_alpha_run(depth_max: 1)
  p info
  hand = info[:hand]
  puts "指し手: #{hand}"
  tp mediator.position_map
  mediator.execute(hand.to_sfen, executor_class: PlayerExecutorCpu)
end

# mediator.execute("▲17飛", executor_class: PlayerExecutorCpu)
# mediator.execute("△23飛", executor_class: PlayerExecutorCpu)
# mediator.execute("▲19飛", executor_class: PlayerExecutorCpu)
# mediator.execute("△21飛", executor_class: PlayerExecutorCpu)
#
# # mediator.execute("▲１七飛", executor_class: PlayerExecutorCpu)
# # tp mediator.position_map
# # mediator.player_at(:black).evaluator.score  # => 0
# # mediator.player_at(:black).evaluator.score2 # => 0
#
# mediator.player_at(:black).brain.nega_alpha_run(depth_max: 1) # => {:hand=>#<▲２八香(29)>, :score=>0, :depth=>0, :reading_hands=>[#<▲２八香(29)>, #<△９一飛(21)>]}
# ~> /Users/ikeda/src/warabi/lib/warabi/brain.rb:107:in `nega_alpha': Warabi::MustNotHappen (Warabi::MustNotHappen)
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/brain.rb:14:in `nega_alpha_run'
# ~> 	from -:20:in `block in <main>'
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
# >> {:hand=>#<▲１三飛成(14)>, :score=>200, :eval_times=>1, :readout=>[#<▲１三飛成(14)>]}
# >> 指し手: ▲１三飛成(14)
# >> --------------------------------------------------------------------------------
# >> 後手の持駒：なし
# >>   ２ １
# >> +------+
# >> |v飛 ・|一
# >> | ・ ・|二
# >> | ・ 龍|三
# >> | ・ ・|四
# >> | ・ ・|五
# >> +------+
# >> 先手の持駒：なし
# >> 手数＝1 ▲１三飛成(14) まで
# >> 
# >> 後手番
# >> {:hand=>#<△２三飛成(21)>, :score=>0, :eval_times=>2, :readout=>[#<△２三飛成(21)>]}
# >> 指し手: △２三飛成(21)
# >> |----------------------+---|
# >> | -1771441069522554039 | 1 |
# >> |----------------------+---|
# >> --------------------------------------------------------------------------------
# >> 後手の持駒：なし
# >>   ２ １
# >> +------+
# >> | ・ ・|一
# >> | ・ ・|二
# >> |v龍 龍|三
# >> | ・ ・|四
# >> | ・ ・|五
# >> +------+
# >> 先手の持駒：なし
# >> 手数＝2 △２三飛成(21) まで
# >> 
# >> 先手番
# >> {:hand=>#<▲２三龍(13)>, :score=>4300, :eval_times=>5, :readout=>[#<▲２三龍(13)>]}
# >> 指し手: ▲２三龍(13)
# >> |----------------------+---|
# >> | -1771441069522554039 | 1 |
# >> | -1147201356111450762 | 1 |
# >> |----------------------+---|
# >> --------------------------------------------------------------------------------
# >> 後手の持駒：なし
# >>   ２ １
# >> +------+
# >> | ・ ・|一
# >> | ・ ・|二
# >> | 龍 ・|三
# >> | ・ ・|四
# >> | ・ ・|五
# >> +------+
# >> 先手の持駒：飛
# >> 手数＝3 ▲２三龍(13) まで
# >> 
# >> 後手番
