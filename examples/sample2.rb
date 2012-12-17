# -*- coding: utf-8 -*-
#
# 移動可能なルートの確認
#

begin
  require_relative "../lib/bushido"
rescue LoadError
  require File.expand_path(File.join(File.dirname(__FILE__), "../lib/bushido"))
end

include Bushido

field = Field.new
player = Player.create2(:black, field)
player.initial_put_on("５五馬")
player.soldiers.first.moveable_points.each{|point|
  field.put_on_at(point, "○")
}
puts field
# >> +----+----+----+----+----+----+----+----+----+----+
# >> |  9 |  8 |  7 |  6 |  5 |  4 |  3 |  2 |  1 |    |
# >> +----+----+----+----+----+----+----+----+----+----+
# >> | ○ |    |    |    |    |    |    |    | ○ | 一 |
# >> |    | ○ |    |    |    |    |    | ○ |    | 二 |
# >> |    |    | ○ |    |    |    | ○ |    |    | 三 |
# >> |    |    |    | ○ | ○ | ○ |    |    |    | 四 |
# >> |    |    |    | ○ | 馬 | ○ |    |    |    | 五 |
# >> |    |    |    | ○ | ○ | ○ |    |    |    | 六 |
# >> |    |    | ○ |    |    |    | ○ |    |    | 七 |
# >> |    | ○ |    |    |    |    |    | ○ |    | 八 |
# >> | ○ |    |    |    |    |    |    |    | ○ | 九 |
# >> +----+----+----+----+----+----+----+----+----+----+
