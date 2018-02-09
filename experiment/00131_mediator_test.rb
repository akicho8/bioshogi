# 棋譜の入力
require "./example_helper"

mediator = Mediator.test(init: "▲２七歩 ▲２八飛 △２三歩 △２二飛", exec: ["２六歩", "２四歩(23)"])
mediator.ki2_hand_logs          # => ["▲２六歩", "△２四歩"]

Mediator.simple_test(init: "▲９七歩").players.collect{|e|e.evaluate} # => [100, -100]
  # .should == [100, -100]


Board.size_change([2, 2]) do
  mediator = Mediator.simple_test(init: "▲１二歩", pieces_set: "▲歩")
  mediator.player_at(:black).brain.all_hands # => ["▲１一歩成(12)", "▲２二歩打"]

  # puts mediator.to_s
  mediator.player_at(:black).brain.eval_list # => [{:hand=>"▲１一歩成(12)", :score=>1305}, {:hand=>"▲２二歩打", :score=>200}]
  # puts mediator.to_s
end
