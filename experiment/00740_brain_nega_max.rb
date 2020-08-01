require "./example_helper"

# Bioshogi.logger = ActiveSupport::Logger.new(STDOUT)

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

brain = mediator.player_at(:black).brain
brain.diver_dive(depth_max: 0) # => [-100, []]
brain.diver_dive(depth_max: 1) # => [105, [<▲１三飛(14)>]]
brain.diver_dive(depth_max: 2) # => [-100, [<▲２四飛(14)>, <△２二飛(12)>]]
brain.diver_dive(depth_max: 3) # => [105, [<▲１三飛(14)>, <△１三飛(12)>, <▲１三香(15)>]]
brain.diver_dive(depth_max: 4) # => [-100, [<▲２四飛(14)>, <△１四歩(13)>, <▲２三飛(24)>, <△１三飛(12)>]]

brain.player.location           # => <black>

brain.smart_score_list(depth_max: 0) # => [{:hand=><▲１三飛(14)>, :score=>105, :socre2=>105, :best_pv=>[], :eval_times=>1, :sec=>1.7e-05}, {:hand=><▲２四飛(14)>, :score=>-100, :socre2=>-100, :best_pv=>[], :eval_times=>1, :sec=>1.3e-05}]
brain.smart_score_list(depth_max: 1) # => [{:hand=><▲１三飛(14)>, :score=>105, :socre2=>105, :best_pv=>[], :eval_times=>1, :sec=>1.6e-05}, {:hand=><▲２四飛(14)>, :score=>-100, :socre2=>-100, :best_pv=>[], :eval_times=>1, :sec=>1.2e-05}]
brain.smart_score_list(depth_max: 2) # => [{:hand=><▲１三飛(14)>, :score=>105, :socre2=>105, :best_pv=>[], :eval_times=>1, :sec=>1.4e-05}, {:hand=><▲２四飛(14)>, :score=>-100, :socre2=>-100, :best_pv=>[], :eval_times=>1, :sec=>1.2e-05}]
brain.smart_score_list(depth_max: 3) # => [{:hand=><▲１三飛(14)>, :score=>105, :socre2=>105, :best_pv=>[], :eval_times=>1, :sec=>1.4e-05}, {:hand=><▲２四飛(14)>, :score=>-100, :socre2=>-100, :best_pv=>[], :eval_times=>1, :sec=>1.1e-05}]
