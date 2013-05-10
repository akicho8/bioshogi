# -*- coding: utf-8 -*-
# ５五将棋の例

require "./example_helper"

Board.size_change([5, 5])
mediator = Mediator.start
soldiers = ["５五玉", "４五金", "３五銀", "２五角", "１五飛", "５四歩"]
mediator.players.each do |player|
  _soldiers = soldiers.collect{|s|
    s = MiniSoldier.from_str(s)
    s.merge(point: s[:point].as_location(player.location))
  }
  player.initial_soldiers(_soldiers)
end
mediator.pieces_clear
p mediator
mediator.execute("２四銀")
mediator.execute("４二銀")
mediator.execute("３四角")
mediator.execute("３二角")
mediator.execute("２三銀")
mediator.execute("４三銀")
mediator.execute("１二銀")
mediator.execute("同金") # !> method redefined; discarding old promoted=
mediator.execute("同角")
p mediator
# >> 1手目: ▲先手番
# >>   ５ ４ ３ ２ １
# >> +---------------+
# >> |v飛v角v銀v金v玉|一
# >> | ・ ・ ・ ・v歩|二
# >> | ・ ・ ・ ・ ・|三
# >> | 歩 ・ ・ ・ ・|四
# >> | 玉 金 銀 角 飛|五
# >> +---------------+
# >> ▲先手の持駒:
# >> ▽後手の持駒:
# >> 
# >> 10手目: ▽後手番
# >>   ５ ４ ３ ２ １
# >> +---------------+
# >> |v飛 ・ ・ ・v玉|一
# >> | ・ ・v角 ・ 角|二
# >> | ・v銀 ・ ・ ・|三
# >> | 歩 ・ ・ ・ ・|四
# >> | 玉 金 ・ ・ 飛|五
# >> +---------------+
# >> ▲先手の持駒:歩 金
# >> ▽後手の持駒:銀
# >> 
