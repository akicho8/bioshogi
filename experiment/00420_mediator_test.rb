require "./example_helper"

mediator = Mediator.test1(init: "▲２七歩 ▲２八飛 △２三歩 △２二飛", execute: ["２六歩", "２四歩(23)"])
mediator.to_ki2_a          # => ["▲２六歩", "△２四歩"]

Mediator.test1(init: "▲９七歩").players.collect{|e|e.evaluate} # => 

Board.dimensiton_change([2, 2]) do
  mediator = Mediator.test1(init: "▲１二歩", pieces_set: "▲歩")
  mediator.player_at(:black).brain.normal_all_hands  # => 
  mediator.player_at(:black).brain.fast_score_list # => 
end
# ~> -:6:in `block in <main>': undefined method `evaluate' for #<Warabi::Player:0x00007fc89ec27d60> (NoMethodError)
# ~> Did you mean?  evaluator
# ~> 	from -:6:in `collect'
# ~> 	from -:6:in `<main>'
