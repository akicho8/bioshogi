# NegaMaxアルゴリズム同士の対決

require "./example_helper"

mediator = Mediator.start
mediator.piece_plot
loop do
  think_result = mediator.current_player.brain.think_by_minmax(depth: 1, random: true)
  hand = InputParser.slice_one(think_result[:hand])
  p hand
  mediator.execute(hand)
  p mediator
  last_captured_piece = mediator.reverse_player.last_captured_piece
  # break
  if last_captured_piece && last_captured_piece.key == :king
    break
  end
end
p mediator.kif_hand_logs.join(" ")
