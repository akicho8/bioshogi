require "./example_helper"

info = Parser.parse("▲１六歩 △１四歩 ▲１五歩 △１五歩")
puts info.to_ki2

# >> 手合割：平手
# >> 
# >> ▲１六歩 △１四歩 ▲１五歩 △同　歩
# >> まで4手で後手の勝ち
