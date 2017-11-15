require "./example_helper"

Parser::Ki2Parser.parse("７六歩").move_infos.collect { |e| e[:mov] } # => ["▲７六歩"]
Parser::Ki2Parser.parse("７六歩打 ▲７六歩").move_infos.collect { |e| e[:mov] } # => ["▲７六歩打", "▽７六歩"]
