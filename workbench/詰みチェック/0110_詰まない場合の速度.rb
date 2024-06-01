# container.opponent_player.create_all_hands(legal_only: true).none? が最速

require "../setup"

container = Container::Basic.new
container.placement_from_preset("平手")
brain = container.opponent_player.brain

# (1) 先手が王手をかけている？
Benchmark.ms { p container.current_player.mate_advantage? } # => 0.30399998649954796

# (2) 後手に応手がない？
Benchmark.ms { p brain.iterative_deepening(depth_max_range: 0..0).none? }                  # => 8.87700030580163
Benchmark.ms { p container.opponent_player.create_all_hands(legal_only: true).to_a.empty? } # => 5.952999927103519
Benchmark.ms { p container.opponent_player.create_all_hands(legal_only: true).none? }       # => 0.21999981254339218

# 簡単メソッド
Benchmark.ms { p container.current_player.op_mate? }        # => 0.16300007700920105
Benchmark.ms { p container.opponent_player.my_mate? }       # => 0.23899972438812256
# >> false
# >> false
# >> false
# >> false
# >> false
# >> false
