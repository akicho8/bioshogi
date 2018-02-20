require "./example_helper"

mediator = Mediator.new
mediator.players.collect { |e| e.evaluator.score } # => [0, 0]

mediator.board.placement_from_human("▲９七歩")
mediator.players.collect { |e| e.evaluator.score } # => [100, -100]

mediator.board.placement_from_human("▲９七歩 △１三歩")
mediator.players.collect { |e| e.evaluator.score } # => [0, 0]
