# 詰む場合は
# container.opponent_player.create_all_hands(legal_only: true).none? が最速

require "../setup"

container = Container.create
container.placement_from_bod <<~EOT
後手の持駒：飛角金銀桂香
+---+
|v玉|
| 金|
| 金|
+---+
先手の持駒：飛角金銀桂香
手数＝0
EOT

brain = container.opponent_player.brain

require 'active_support/core_ext/benchmark'

# (1) 先手が王手をかけている？
Benchmark.ms { p container.current_player.mate_advantage? } # => 0.14999997802078724

# (2) 後手に応手がない？
Benchmark.ms { p brain.iterative_deepening(depth_max_range: 0..0).none? }                  # => 54.78799995034933
Benchmark.ms { p container.opponent_player.create_all_hands(legal_only: true).to_a.empty? } # => 51.81600013747811
Benchmark.ms { p container.opponent_player.create_all_hands(legal_only: true).none? }       # => 51.1570000089705

# 簡単メソッド
Benchmark.ms { p container.current_player.op_mate? }        # => 54.32800017297268
Benchmark.ms { p container.opponent_player.my_mate? }       # => 53.73200005851686
# >> true
# >> true
# >> true
# >> true
# >> true
# >> true
