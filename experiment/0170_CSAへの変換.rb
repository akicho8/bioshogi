require "./example_helper"

puts Parser.parse("７六歩 ３四歩").to_csa
# >> V2.2
# >> PI
# >> +
# >> +7776FU
# >> -3334FU
# >> %TORYO
