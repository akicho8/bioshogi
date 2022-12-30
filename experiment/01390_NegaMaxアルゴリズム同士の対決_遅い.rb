# NegaMaxアルゴリズム同士の対決

require "./setup"

container = Container::Basic.start
container.piece_plot
loop do
  think_result = container.current_player.brain.diver_dive(depth_max: 1, random: true)
  hand = InputParser.slice_one(think_result[:hand])
  p hand
  container.execute(hand)
  p container
  captured_soldier = container.opponent_player.executor.captured_soldier
  # break
  if captured_soldier && captured_soldier.piece.key == :king
    break
  end
end
p container.to_kif_a.join(" ")
