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

brain = mediator.player_at(:black).brain(diver_class: NegaScoutDiver)
brain.diver_dive(depth_max: 0) # => [-100, []]
brain.diver_dive(depth_max: 1) # => [105, [<▲１三飛(14)>]]
brain.diver_dive(depth_max: 2) # => [-100, [<▲２四飛(14)>, <△２二飛(12)>]]
brain.diver_dive(depth_max: 3) # => [105, [<▲１三飛(14)>, <△１三飛(12)>, <▲１三香(15)>]]
brain.diver_dive(depth_max: 4) # => [-100, [<▲２四飛(14)>, <△１四歩(13)>, <▲２三飛(24)>, <△１三飛(12)>]]

brain.smart_score_list(depth_max: 0) # => [{:hand=><▲１三飛(14)>, :score=>105, :socre2=>105, :best_pv=>[], :eval_times=>1, :sec=>2.1e-05}, {:hand=><▲２四飛(14)>, :score=>-100, :socre2=>-100, :best_pv=>[], :eval_times=>1, :sec=>2.0e-05}]
brain.smart_score_list(depth_max: 1) # => [{:hand=><▲２四飛(14)>, :score=>-100, :socre2=>-100, :best_pv=>[<△２二飛(12)>], :eval_times=>2, :sec=>0.000307}, {:hand=><▲１三飛(14)>, :score=>-3995, :socre2=>-3995, :best_pv=>[<△１三飛(12)>], :eval_times=>2, :sec=>0.000341}]
brain.smart_score_list(depth_max: 2) # => [{:hand=><▲１三飛(14)>, :score=>105, :socre2=>105, :best_pv=>[<△１三飛(12)>, <▲１三香(15)>], :eval_times=>10, :sec=>0.00217}, {:hand=><▲２四飛(14)>, :score=>105, :socre2=>105, :best_pv=>[<△１四歩(13)>, <▲１四香(15)>], :eval_times=>15, :sec=>0.001934}]
brain.smart_score_list(depth_max: 3) # => [{:hand=><▲２四飛(14)>, :score=>-100, :socre2=>-100, :best_pv=>[<△１四歩(13)>, <▲２三飛(24)>, <△１三飛(12)>], :eval_times=>44, :sec=>0.01091}, {:hand=><▲１三飛(14)>, :score=>-1125, :socre2=>-1125, :best_pv=>[<△１三飛(12)>, <▲１三香(15)>, <△１三香(11)>], :eval_times=>41, :sec=>0.008963}]
