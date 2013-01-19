# -*- coding: utf-8 -*-

begin
  require_relative "../lib/bushido"
rescue LoadError
  require File.expand_path(File.join(File.dirname(__FILE__), "../lib/bushido"))
end

include Bushido

frame = LiveFrame.basic_instance
frame.piece_plot
[
  "７六歩", "８四歩", "７八金", "３二金",
  "２六歩", "８五歩", "７七角", "３四歩",
  "８八銀", "７七角成",
].each{|input|
  frame.execute(input)
}
puts frame.board
pp frame.a_move_logs
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> |v香v桂v銀v金v玉 ・v銀v桂v香|一
# >> | ・v飛 ・ ・ ・ ・v金 ・ ・|二
# >> |v歩 ・v歩v歩v歩v歩 ・v歩v歩|三
# >> | ・ ・ ・ ・ ・ ・v歩 ・ ・|四
# >> | ・v歩 ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ 歩 ・ ・ ・ ・ 歩 ・|六
# >> | 歩 歩v馬 歩 歩 歩 歩 ・ 歩|七
# >> | ・ 銀 金 ・ ・ ・ ・ 飛 ・|八
# >> | 香 桂 ・ ・ 玉 金 銀 桂 香|九
# >> +---------------------------+
# >> ["▲7六歩(77)",
# >>  "▽8四歩(83)",
# >>  "▲7八金(69)",
# >>  "▽3二金(41)",
# >>  "▲2六歩(27)",
# >>  "▽8五歩(84)",
# >>  "▲7七角(88)",
# >>  "▽3四歩(33)",
# >>  "▲8八銀(79)",
# >>  "▽7七角成(22)"]
