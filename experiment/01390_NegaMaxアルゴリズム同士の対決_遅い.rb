# NegaMaxアルゴリズム同士の対決

require "./setup"

xcontainer = Xcontainer.start
xcontainer.piece_plot
loop do
  think_result = xcontainer.current_player.brain.diver_dive(depth_max: 1, random: true)
  hand = InputParser.slice_one(think_result[:hand])
  p hand
  xcontainer.execute(hand)
  p xcontainer
  captured_soldier = xcontainer.opponent_player.executor.captured_soldier
  # break
  if captured_soldier && captured_soldier.piece.key == :king
    break
  end
end
p xcontainer.to_kif_a.join(" ")
