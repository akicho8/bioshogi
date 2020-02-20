require "../example_helper"

# Bioshogi.logger = ActiveSupport::Logger.new(STDOUT)

Board.promotable_disable
Board.dimensiton_change([4, 4])

mediator = Mediator.new
# mediator.player_at(:white).pieces_add("金")
mediator.player_at(:black).pieces_add("金金")
mediator.board.placement_from_shape <<~EOT
+------------+
| ・ ・ ・ ・|
| ・ ・v玉 ・|
| ・ ・ ・ ・|
| ・ ・ 金 ・|
+------------+
EOT
# puts mediator.to_bod
tp mediator.player_at(:black).create_all_hands

# brain = mediator.player_at(:black).brain(diver_class: NegaScoutDiver)
# brain.diver_dive(depth_max: 1) # => [-37540, [<▲３三金(24)>]]
# records = brain.iterative_deepening(depth_max_range: 1..3)
# tp Brain.human_format(records)

# tp brain.smart_score_list(depth_max: 2)

# brain.diver_dive(depth_max: 1) # => [105, [<▲１三飛(14)>]]
# brain.diver_dive(depth_max: 2) # => [-100, [<▲２四飛(14)>, <△２二飛(12)>]]
# brain.diver_dive(depth_max: 3) # => [105, [<▲１三飛(14)>, <△１三飛(12)>, <▲１三香(15)>]]
# brain.diver_dive(depth_max: 4) # => [-100, [<▲２四飛(14)>, <△１四歩(13)>, <▲２三飛(24)>, <△１三飛(12)>]]
# >> |--------------|
# >> | ▲３三金(24) |
# >> | ▲２三金(24) |
# >> | ▲１三金(24) |
# >> | ▲３四金(24) |
# >> | ▲１四金(24) |
# >> | ▲４一金打   |
# >> | ▲３一金打   |
# >> | ▲２一金打   |
# >> | ▲１一金打   |
# >> | ▲４二金打   |
# >> | ▲３二金打   |
# >> | ▲１二金打   |
# >> | ▲４三金打   |
# >> | ▲３三金打   |
# >> | ▲２三金打   |
# >> | ▲１三金打   |
# >> | ▲４四金打   |
# >> | ▲３四金打   |
# >> | ▲１四金打   |
# >> |--------------|
