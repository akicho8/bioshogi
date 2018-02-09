# 棋譜の入力
require "./example_helper"

Mediator.simple_test(init: "▲９七歩").players.collect{|e|e.evaluate} # => [100, 0]
  # .should == [100, -100]
# >> ["/Users/ikeda/src/warabi/lib/warabi/evaluator.rb:46", :player_score_for, ["▲９七歩"]]
# >> ["/Users/ikeda/src/warabi/lib/warabi/evaluator.rb:46", :player_score_for, []]
