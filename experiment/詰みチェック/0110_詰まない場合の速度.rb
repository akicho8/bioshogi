# mediator.opponent_player.create_all_hands(legal_only: true).none? が最速

require "../setup"

mediator = Mediator.new
mediator.placement_from_preset("平手")
brain = mediator.opponent_player.brain

# (1) 先手が王手をかけている？
Benchmark.ms { p mediator.current_player.mate_advantage? } # => 0.6550000980496407

# (2) 後手に応手がない？
Benchmark.ms { p brain.iterative_deepening(depth_max_range: 0..0).none? }                  # => 18.536000046879053
Benchmark.ms { p mediator.opponent_player.create_all_hands(legal_only: true).to_a.empty? } # => 19.909000024199486
Benchmark.ms { p mediator.opponent_player.create_all_hands(legal_only: true).none? }       # => 0.619000056758523

# 簡単メソッド
Benchmark.ms { p mediator.current_player.op_mate? }        # => 0.45499997213482857
Benchmark.ms { p mediator.opponent_player.my_mate? }       # => 0.45199994929134846
# >> false
# >> false
# >> false
# >> false
# >> false
# >> false
