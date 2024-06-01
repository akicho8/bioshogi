require "./setup"

container = Container::Basic.start
player = container.player_at(:black)
brain = container.player_at(:black).brain(diver_class: AI::Diver::NegaAlphaDiver, evaluator_class: Evaluator::Level3)
@records = brain.iterative_deepening(depth_max_range: 0..0)
@records.first[:hand].to_s == "▲６八銀(79)"
# tp AI::Brain.human_format(@records)

