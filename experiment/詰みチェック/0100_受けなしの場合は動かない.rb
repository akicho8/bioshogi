# 詰む場合は
# mediator.opponent_player.create_all_hands(legal_only: true).none? が最速

require "../setup"

mediator = Mediator.new
mediator.placement_from_bod <<~EOT
後手の持駒：飛角金銀桂香
+---------+
| ・ ・v玉|
| ・ ・ ・|
| 馬 金 ・|
+---------+
先手の持駒：飛角金銀桂香
手数＝0
EOT

brain = mediator.opponent_player.brain

require 'active_support/core_ext/benchmark'

# (1) 先手が王手をかけている？
Benchmark.ms { p mediator.current_player.mate_advantage? } # => 0.19200006499886513

# (2) 後手に応手がない？
Benchmark.ms { p brain.iterative_deepening(depth_max_range: 0..0).none? }                  # => 55.250999983400106
Benchmark.ms { p mediator.opponent_player.create_all_hands(legal_only: true).to_a.empty? } # => 50.93799997121096
Benchmark.ms { p mediator.opponent_player.create_all_hands(legal_only: true).none? }       # => 0.5410001613199711

# 簡単メソッド
Benchmark.ms { p mediator.current_player.op_mate? }        # => 0.610999995842576
Benchmark.ms { p mediator.opponent_player.my_mate? }       # => 0.5789999850094318
# >> true
# >> false
# >> false
# >> false
# >> false
# >> false
