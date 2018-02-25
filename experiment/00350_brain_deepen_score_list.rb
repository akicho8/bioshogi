require "./example_helper"

# Warabi.logger = ActiveSupport::Logger.new(STDOUT)

Board.dimensiton_change([2, 5])

mediator = Mediator.new
mediator.placement_from_bod <<~EOT
後手の持駒：飛 香
  ２ １
+------+
| ・v香|一
| 歩 ・|二
| ・ ・|三
| ・ ・|四
| ・v飛|五
+------+
先手の持駒：なし
手数＝0 まで
EOT

tp mediator.player_at(:black).brain.smart_score_list(depth_max: 3) # => [{:hand=>#<▲２一歩成(22)>, :score=>-4930, :readout=>[#<△１三香成(11)>, #<▲１一と(21)>, #<△２五飛成(15)>], :eval_times=>74}]
exit



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
# tp brain.deepen_score_list(depth_max_range: 0..0) # => [{:hand=>#<▲１三飛(14)>, :score=>105, :readout=>[], :eval_times=>1}, {:hand=>#<▲２四飛(14)>, :score=>-100, :readout=>[], :eval_times=>2}]
# tp brain.deepen_score_list(depth_max_range: 0..1) # => [{:hand=>#<▲２四飛(14)>, :score=>-100, :readout=>[#<△２二飛(12)>], :eval_times=>3}, {:hand=>#<▲１三飛(14)>, :score=>-3995, :readout=>[#<△１三飛(12)>], :eval_times=>1}]
# tp brain.deepen_score_list(depth_max_range: 0..2) # => [{:hand=>#<▲１三飛(14)>, :score=>105, :readout=>[#<△１三飛(12)>, #<▲１三香(15)>], :eval_times=>8}, {:hand=>#<▲２四飛(14)>, :score=>105, :readout=>[#<△１四歩(13)>, #<▲１四香(15)>], :eval_times=>30}]
# tp brain.deepen_score_list(depth_max_range: 0..3) # => [{:hand=>#<▲２四飛(14)>, :score=>-100, :readout=>[#<△１四歩(13)>, #<▲２三飛(24)>, #<△１三飛(12)>], :eval_times=>196}, {:hand=>#<▲１三飛(14)>, :score=>-1125, :readout=>[#<△１三飛(12)>, #<▲１三香(15)>, #<△１三香(11)>], :eval_times=>86}]
tp brain.deepen_score_list(depth_max_range: 4..4) # => 
# >> |----------------+-------+---------------------------------------------------------+------------|
# >> | hand           | score | readout                                                 | eval_times |
# >> |----------------+-------+---------------------------------------------------------+------------|
# >> | ▲２一歩成(22) | -4930 | [#<△１三香成(11)>, #<▲１一と(21)>, #<△２五飛成(15)>] |         74 |
# >> |----------------+-------+---------------------------------------------------------+------------|
