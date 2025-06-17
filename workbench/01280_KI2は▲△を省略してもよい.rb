require "#{__dir__}/setup"

tp Parser::Ki2Parser.parse("７六歩").pi.move_infos
tp Parser::Ki2Parser.parse("７六歩打 ▲７六歩").pi.move_infos
# >> |--------|
# >> | input  |
# >> |--------|
# >> | ７六歩 |
# >> |--------|
# >> |----------|
# >> | input    |
# >> |----------|
# >> | ７六歩打 |
# >> | ▲７六歩 |
# >> |----------|
