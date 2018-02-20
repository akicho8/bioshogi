require "./example_helper"

Board.dimensiton_change([3, 3])
mediator = Mediator.new
mediator.pieces_set("▲歩")
mediator.board.placement_from_shape <<~EOT
+---------+
| ・ ・ ・|
| ・ 歩 ・|
| ・ ・ ・|
+---------+
EOT
brain = mediator.player_at(:black).brain
brain.all_hands.collect(&:to_kif)                               # => ["▲２一歩成(22)", "▲３二歩打", "▲１二歩打", "▲３三歩打", "▲１三歩打"]
brain.score_list.collect { |e| e.merge(hand: e[:hand].to_kif) } # => [{:hand=>"▲２一歩成(22)", :score=>1305}, {:hand=>"▲３二歩打", :score=>200}, {:hand=>"▲１二歩打", :score=>200}, {:hand=>"▲３三歩打", :score=>200}, {:hand=>"▲１三歩打", :score=>200}]
