require "./example_helper"
require "stackprof"

mediator = Mediator.start
mediator.execute("▲６八銀")
mediator.instance_variables     # => [:@board, :@turn_info, :@players, :@first_state_board_sfen, :@variables, :@var_stack, :@params, :@hand_logs]

mediator = MediatorSimple.start
mediator.execute("▲６八銀")
mediator.instance_variables     # => 

# Warabi.logger = ActiveSupport::Logger.new(STDOUT)

mediator = Mediator.new
mediator.pieces_set("▲歩△歩")
mediator.board.placement_from_shape <<~EOT
+------+
|v飛v香|
| ・ ・|
| ・v歩|
|v香 ・|
|v歩 歩|
| ・ 香|
| 歩 ・|
| ・ ・|
| 香 飛|
+------+
  EOT


StackProf.run(mode: :cpu, out: "stackprof.dump", raw: true) do
  2.times do
    info = mediator.current_player.brain.nega_max_run(depth_max: 1)
    hand = info[:hand]
    mediator.execute(hand.to_sfen, executor_class: PlayerExecutorCpu)
  end
end

system "stackprof stackprof.dump"
system "stackprof stackprof.dump --method Warabi::Point.lookup"

# ~> /Users/ikeda/src/warabi/lib/warabi/player_executor_human.rb:10:in `turn_ended_process': undefined method `hand_logs' for #<Warabi::MediatorSimple:0x00007fc3d93d5c58> (NoMethodError)
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/player_executor_base.rb:48:in `execute'
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/player.rb:20:in `execute'
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/mediator_simple.rb:20:in `block in execute'
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/mediator_simple.rb:19:in `each'
# ~> 	from /Users/ikeda/src/warabi/lib/warabi/mediator_simple.rb:19:in `execute'
# ~> 	from -:9:in `<main>'
