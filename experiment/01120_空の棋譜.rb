require "./example_helper"

info = Parser.parse("")
tp info.header.to_h
tp info.header.to_names_h
tp info.header.meta_info
tp info.header.__to_meta_h
tp info.header.to_kisen_a
tp info.header.__to_simple_names_h
tp info.header.tags
puts info.to_ki2
# >> |------+--|
# >> | 先手 |  |
# >> | 後手 |  |
# >> |------+--|
# >> |--|
# >> |  |
# >> |--|
# >> |------+--|
# >> | 先手 |  |
# >> | 後手 |  |
# >> |------+--|
# >> 手合割：平手
# >> 
# >> まで0手で後手の勝ち
