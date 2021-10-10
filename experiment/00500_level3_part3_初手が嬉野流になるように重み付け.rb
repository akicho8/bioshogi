require "./setup"

mediator = Mediator.start
player = mediator.player_at(:black)
brain = mediator.player_at(:black).brain(diver_class: Diver::NegaAlphaDiver, evaluator_class: Evaluator::Level3)
@records = brain.iterative_deepening(depth_max_range: 0..0)
@records.first[:hand].to_s == "▲６八銀(79)"
# tp Brain.human_format(@records)

