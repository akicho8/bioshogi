# 詰む場合は
# container.opponent_player.create_all_hands(legal_only: true).none? が最速

require "../setup"

container = Container::Basic.new
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
Benchmark.ms { p container.current_player.mate_advantage? } # => 0.09700004011392593

# (2) 後手に応手がない？
Benchmark.ms { p brain.iterative_deepening(depth_max_range: 0..0).none? }                  # => 22.133999969810247
Benchmark.ms { p container.opponent_player.create_all_hands(legal_only: true).to_a.empty? } # => 21.625000052154064
Benchmark.ms { p container.opponent_player.create_all_hands(legal_only: true).none? }       # => 23.07899994775653

# 簡単メソッド
Benchmark.ms { p container.current_player.op_mate? }        # => 20.768000278621912
Benchmark.ms { p container.opponent_player.my_mate? }       # => 20.97199996933341
# >> true
# >> true
# >> true
# >> true
# >> true
# >> true
