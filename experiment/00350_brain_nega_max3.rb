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

brain = mediator.player_at(:black).brain
brain.nega_alpha_run(depth_max: 0) # => {:score=>-100, :readout=>[]}
brain.nega_alpha_run(depth_max: 1) # => {:hand=>#<▲１三飛(14)>, :score=>105, :eval_times=>1, :readout=>[#<▲１三飛(14)>]}
brain.nega_alpha_run(depth_max: 2) # => {:hand=>#<▲２四飛(14)>, :score=>-100, :eval_times=>4, :readout=>[#<▲２四飛(14)>, #<△２二飛(12)>]}
brain.nega_alpha_run(depth_max: 3) # => {:hand=>#<▲１三飛(14)>, :score=>105, :eval_times=>9, :readout=>[#<▲１三飛(14)>, #<△１三飛(12)>, #<▲１三香(15)>]}
brain.nega_alpha_run(depth_max: 4) # => {:hand=>#<▲２四飛(14)>, :score=>-100, :eval_times=>59, :readout=>[#<▲２四飛(14)>, #<△１四歩(13)>, #<▲２三飛(24)>, #<△１三飛(12)>]}

brain.smart_score_list(depth_max: 0) # => [{:hand=>#<▲１三飛(14)>, :score=>105, :readout=>[], :eval_times=>nil}, {:hand=>#<▲２四飛(14)>, :score=>-100, :readout=>[], :eval_times=>nil}]
brain.smart_score_list(depth_max: 1) # => [{:hand=>#<▲２四飛(14)>, :score=>-100, :readout=>[#<△２二飛(12)>], :eval_times=>1}, {:hand=>#<▲１三飛(14)>, :score=>-3995, :readout=>[#<△１三飛(12)>], :eval_times=>1}]
brain.smart_score_list(depth_max: 2) # => [{:hand=>#<▲１三飛(14)>, :score=>105, :readout=>[#<△１三飛(12)>, #<▲１三香(15)>], :eval_times=>8}, {:hand=>#<▲２四飛(14)>, :score=>105, :readout=>[#<△１四歩(13)>, #<▲１四香(15)>], :eval_times=>12}]
brain.smart_score_list(depth_max: 3) # => [{:hand=>#<▲２四飛(14)>, :score=>-100, :readout=>[#<△１四歩(13)>, #<▲２三飛(24)>, #<△１三飛(12)>], :eval_times=>28}, {:hand=>#<▲１三飛(14)>, :score=>-1125, :readout=>[#<△１三飛(12)>, #<▲１三香(15)>, #<△１三香(11)>], :eval_times=>27}]
