# -*- coding: utf-8 -*-
#
# 盤面上の駒を確認
#

begin
  require_relative "../lib/bushido"
rescue LoadError
  require File.expand_path(File.join(File.dirname(__FILE__), "../lib/bushido"))
end

include Bushido

field = Field.new
player = Player.new(:black, field, :lower)
player.setup
puts field
field["５五"]      # => nil
field["８八"].name # => "▲8八角"
field["２八"].name # => "▲2八飛"
field["５九"].name # => "▲5九玉"
# >> +----+----+----+----+----+----+----+----+----+----+
# >> |  9 |  8 |  7 |  6 |  5 |  4 |  3 |  2 |  1 |    |
# >> +----+----+----+----+----+----+----+----+----+----+
# >> |    |    |    |    |    |    |    |    |    | 一 |
# >> |    |    |    |    |    |    |    |    |    | 二 |
# >> |    |    |    |    |    |    |    |    |    | 三 |
# >> |    |    |    |    |    |    |    |    |    | 四 |
# >> |    |    |    |    |    |    |    |    |    | 五 |
# >> |    |    |    |    |    |    |    |    |    | 六 |
# >> | 歩 | 歩 | 歩 | 歩 | 歩 | 歩 | 歩 | 歩 | 歩 | 七 |
# >> |    | 角 |    |    |    |    |    | 飛 |    | 八 |
# >> | 香 | 桂 | 銀 | 金 | 玉 | 金 | 銀 | 桂 | 香 | 九 |
# >> +----+----+----+----+----+----+----+----+----+----+
