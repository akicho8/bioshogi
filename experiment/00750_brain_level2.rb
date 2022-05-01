require "./setup"

# Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

Board.promotable_disable
Board.dimensiton_change([2, 5])

mediator = Mediator.new
mediator.board.placement_from_shape <<~EOT
+------+
| ・v香|
| ・v飛|
| ・v歩|
| ・ 飛|
| ・ 香|
+------+
EOT

brain = mediator.player_at(:black).brain(evaluator_class: Evaluator::Level2)
brain.diver_dive(depth_max: 0) # => [-100, []]
brain.diver_dive(depth_max: 1) # => [106, [<▲１三飛(14)>]]
brain.diver_dive(depth_max: 2) # => [-100, [<▲２四飛(14)>, <△２二飛(12)>]]
brain.diver_dive(depth_max: 3) # => [105, [<▲２四飛(14)>, <△１四歩(13)>, <▲１四飛(24)>]]
brain.diver_dive(depth_max: 4) # => [-100, [<▲２四飛(14)>, <△１四歩(13)>, <▲２三飛(24)>, <△１三飛(12)>]]

brain.player.location           # => <black>

brain.smart_score_list(depth_max: 0) # => [{:hand=><▲１三飛(14)>, :score=>106, :socre2=>106, :best_pv=>[], :eval_times=>1, :sec=>4.4e-05}, {:hand=><▲２四飛(14)>, :score=>-100, :socre2=>-100, :best_pv=>[], :eval_times=>1, :sec=>4.9e-05}]
brain.smart_score_list(depth_max: 1) # => [{:hand=><▲１三飛(14)>, :score=>106, :socre2=>106, :best_pv=>[], :eval_times=>1, :sec=>4.2e-05}, {:hand=><▲２四飛(14)>, :score=>-100, :socre2=>-100, :best_pv=>[], :eval_times=>1, :sec=>4.7e-05}]
brain.smart_score_list(depth_max: 2) # => [{:hand=><▲１三飛(14)>, :score=>106, :socre2=>106, :best_pv=>[], :eval_times=>1, :sec=>4.2e-05}, {:hand=><▲２四飛(14)>, :score=>-100, :socre2=>-100, :best_pv=>[], :eval_times=>1, :sec=>4.8e-05}]
brain.smart_score_list(depth_max: 3) # => [{:hand=><▲１三飛(14)>, :score=>106, :socre2=>106, :best_pv=>[], :eval_times=>1, :sec=>4.1e-05}, {:hand=><▲２四飛(14)>, :score=>-100, :socre2=>-100, :best_pv=>[], :eval_times=>1, :sec=>4.6e-05}]
