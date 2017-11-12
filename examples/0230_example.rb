# NegaMaxアルゴリズム同士の対決

require "./example_helper"

mediator = Mediator.start
mediator.piece_plot
loop do
  think_result = mediator.current_player.brain.think_by_minmax(depth: 1, random: true)
  hand = Utils.mov_split_one(think_result[:hand])[:input]
  p hand
  mediator.execute(hand)
  p mediator
  last_piece = mediator.reverse_player.last_piece
  # break
  if last_piece && last_piece.key == :king
    break
  end
end
p mediator.kif_hand_logs.join(" ")
