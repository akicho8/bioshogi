# 棋譜の入力
require "./example_helper"

mediator = Mediator.test(init: "▲２七歩 ▲２八飛 △２三歩 △２二飛", exec: ["２六歩", "２四歩(23)"])
mediator.ki2_hand_logs          # => ["▲２六歩", "△２四歩"]
# >> "２七歩"
# >> ["/Users/ikeda/src/warabi/lib/warabi/player.rb:68", :battlers_create, "２七歩", :black]
# >> "２八飛"
# >> ["/Users/ikeda/src/warabi/lib/warabi/player.rb:68", :battlers_create, "２八飛", :black]
# >> "２三歩"
# >> ["/Users/ikeda/src/warabi/lib/warabi/player.rb:68", :battlers_create, "２三歩", :white]
# >> "２二飛"
# >> ["/Users/ikeda/src/warabi/lib/warabi/player.rb:68", :battlers_create, "２二飛", :white]
# >> ["/Users/ikeda/src/warabi/lib/warabi/runner.rb:176", :execute, "歩", #<Warabi::Point:70174783865580 "２六">, ["▲２七歩", "▲２八飛"]]
# >> ["/Users/ikeda/src/warabi/lib/warabi/runner.rb:184", :execute, "歩", ["▲２七歩"]]
# >> ["/Users/ikeda/src/warabi/lib/warabi/runner.rb:176", :execute, "歩", #<Warabi::Point:70174787423320 "２四">, ["△２三歩", "△２二飛"]]
# >> ["/Users/ikeda/src/warabi/lib/warabi/runner.rb:184", :execute, "歩", ["△２三歩"]]
