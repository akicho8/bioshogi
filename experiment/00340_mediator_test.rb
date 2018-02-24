require "./example_helper"

mediator = Mediator.test1(init: "▲２七歩 ▲２八飛 △２三歩 △２二飛", execute: ["２六歩", "２四歩(23)"])
mediator.to_ki2_a          # => ["▲２六歩", "△２四歩"]

Mediator.test1(init: "▲９七歩").players.collect{|e|e.evaluate} # => [100, -100]

Board.dimensiton_change([2, 2]) do
  mediator = Mediator.test1(init: "▲１二歩", pieces_set: "▲歩")
  mediator.player_at(:black).brain.lazy_all_hands  # => [#<▲１一歩成(12)>, #<▲２二歩打>]
  mediator.player_at(:black).brain.fast_score_list # => [{:hand=>#<▲１一歩成(12)>, :score=>1305}, {:hand=>#<▲２二歩打>, :score=>200}]
end
