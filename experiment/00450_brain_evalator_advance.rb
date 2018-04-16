require "./example_helper"

# Warabi.logger = ActiveSupport::Logger.new(STDOUT)

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

brain = mediator.player_at(:black).brain(evaluator_class: EvaluatorAdvance)
brain.diver_dive(depth_max: 0) # => [-100, []]
brain.diver_dive(depth_max: 1) # => [106, [<▲１三飛(14)>]]
brain.diver_dive(depth_max: 2) # => [-100, [<▲２四飛(14)>, <△２二飛(12)>]]
brain.diver_dive(depth_max: 3) # => [105, [<▲２四飛(14)>, <△１四歩(13)>, <▲１四飛(24)>]]
brain.diver_dive(depth_max: 4) # => [-100, [<▲２四飛(14)>, <△１四歩(13)>, <▲２三飛(24)>, <△１三飛(12)>]]

brain.player.location           # => <black>

brain.smart_score_list(depth_max: 0) # => [{:hand=><▲１三飛(14)>, :score=>106, :socre2=>106, :best_pv=>[], :eval_times=>1, :sec=>5.9e-05}, {:hand=><▲２四飛(14)>, :score=>-100, :socre2=>-100, :best_pv=>[], :eval_times=>1, :sec=>9.5e-05}]
brain.smart_score_list(depth_max: 1) # => [{:hand=><▲２四飛(14)>, :score=>-100, :socre2=>-100, :best_pv=>[<△２二飛(12)>], :eval_times=>2, :sec=>0.000364}, {:hand=><▲１三飛(14)>, :score=>-4007, :socre2=>-4007, :best_pv=>[<△１三飛(12)>], :eval_times=>2, :sec=>0.000305}]
brain.smart_score_list(depth_max: 2) # => [{:hand=><▲２四飛(14)>, :score=>105, :socre2=>105, :best_pv=>[<△１四歩(13)>, <▲１四飛(24)>], :eval_times=>12, :sec=>0.002647}, {:hand=><▲１三飛(14)>, :score=>103, :socre2=>103, :best_pv=>[<△１三飛(12)>, <▲１三香(15)>], :eval_times=>9, :sec=>0.001463}]
brain.smart_score_list(depth_max: 3) # => [{:hand=><▲２四飛(14)>, :score=>-100, :socre2=>-100, :best_pv=>[<△１四歩(13)>, <▲２三飛(24)>, <△１三飛(12)>], :eval_times=>28, :sec=>0.005532}, {:hand=><▲１三飛(14)>, :score=>-1125, :socre2=>-1125, :best_pv=>[<△１三飛(12)>, <▲１三香(15)>, <△１三香(11)>], :eval_times=>40, :sec=>0.006623}]
