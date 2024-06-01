# 詰む場合は
# container.opponent_player.create_all_hands(legal_only: true).none? が最速

require "../setup"

container = Container::Basic.new
container.placement_from_bod <<~EOT
後手の持駒：飛角金銀桂香
+---------+
| ・ ・v玉|
| ・ ・ ・|
| 馬 金 ・|
+---------+
先手の持駒：飛角金銀桂香
手数＝0
EOT

brain = container.opponent_player.brain

require 'active_support/core_ext/benchmark'

# (1) 先手が王手をかけている？
Benchmark.ms { p container.current_player.mate_advantage? } # => 0.1309998333454132

# (2) 後手に応手がない？
Benchmark.ms { p brain.iterative_deepening(depth_max_range: 0..0).none? }                  # => 22.880999837070704
Benchmark.ms { p container.opponent_player.create_all_hands(legal_only: true).to_a.empty? } # => 21.046000067144632
Benchmark.ms { p container.opponent_player.create_all_hands(legal_only: true).none? }       # => 0.18800003454089165

# 簡単メソッド
Benchmark.ms { p container.current_player.op_mate? }        # => 0.21399976685643196
Benchmark.ms { p container.opponent_player.my_mate? }       # => 0.2060001716017723
# >> true
# >> false
# >> false
# >> false
# >> false
# >> false
