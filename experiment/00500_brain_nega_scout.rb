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

brain = mediator.player_at(:black).brain(default_diver_class: NegaScoutDiver)
brain.diver_dive(depth_max: 0) # => [-100, []]
brain.diver_dive(depth_max: 1) # => [105, []]
brain.diver_dive(depth_max: 2) # => [-100, [<▲２四飛(14)>, <△２二飛(12)>]]
brain.diver_dive(depth_max: 3) # => [105, []]
brain.diver_dive(depth_max: 4) # => [-100, [<▲２四飛(14)>, <△１四歩(13)>, <▲２三飛(24)>, <△１三飛(12)>]]

brain.smart_score_list(depth_max: 0) # => [{:hand=><▲１三飛(14)>, :score=>105, :socre2=>105, :forecast=>[], :eval_times=>1, :sec=>1.8e-05}, {:hand=><▲２四飛(14)>, :score=>-100, :socre2=>-100, :forecast=>[], :eval_times=>1, :sec=>1.2e-05}]
brain.smart_score_list(depth_max: 1) # => [{:hand=><▲２四飛(14)>, :score=>-100, :socre2=>-100, :forecast=>[], :eval_times=>2, :sec=>0.00026}, {:hand=><▲１三飛(14)>, :score=>-3995, :socre2=>-3995, :forecast=>[], :eval_times=>2, :sec=>0.001164}]
brain.smart_score_list(depth_max: 2) # => [{:hand=><▲１三飛(14)>, :score=>105, :socre2=>105, :forecast=>[], :eval_times=>10, :sec=>0.001469}, {:hand=><▲２四飛(14)>, :score=>105, :socre2=>105, :forecast=>[<△１四歩(13)>, <▲１四香(15)>], :eval_times=>15, :sec=>0.001328}]
brain.smart_score_list(depth_max: 3) # => [{:hand=><▲２四飛(14)>, :score=>-100, :socre2=>-100, :forecast=>[<△１四歩(13)>, <▲２三飛(24)>, <△１三飛(12)>], :eval_times=>44, :sec=>0.006978}, {:hand=><▲１三飛(14)>, :score=>-1125, :socre2=>-1125, :forecast=>[], :eval_times=>41, :sec=>0.006032}]
