require "./setup"

Board.dimensiton_change([5, 5])
xcontainer = Xcontainer.new
soldiers = ["５五玉", "４五金", "３五銀", "２五角", "１五飛", "５四歩"].collect { |e| Soldier.from_str(e, location: :black) }
xcontainer.players.each do |player|
  if player.location.key == :white
    s = soldiers.collect(&:flip)
  else
    s = soldiers
  end
  player.soldier_create(s)
end
xcontainer.piece_box_clear
p xcontainer
xcontainer.execute("２四銀")
xcontainer.execute("４二銀")
xcontainer.execute("３四角")
xcontainer.execute("３二角")
xcontainer.execute("２三銀")
xcontainer.execute("４三銀")
xcontainer.execute("１二銀")
xcontainer.execute("同金")
xcontainer.execute("同角")
p xcontainer
# >> 後手の持駒：なし
# >>   ５ ４ ３ ２ １
# >> +---------------+
# >> |v飛v角v銀v金v玉|一
# >> | ・ ・ ・ ・v歩|二
# >> | ・ ・ ・ ・ ・|三
# >> | 歩 ・ ・ ・ ・|四
# >> | 玉 金 銀 角 飛|五
# >> +---------------+
# >> 先手の持駒：なし
# >> 手数＝0 まで
# >> 
# >> 後手の持駒：銀
# >>   ５ ４ ３ ２ １
# >> +---------------+
# >> |v飛 ・ ・ ・v玉|一
# >> | ・ ・v角 ・ 角|二
# >> | ・v銀 ・ ・ ・|三
# >> | 歩 ・ ・ ・ ・|四
# >> | 玉 金 ・ ・ 飛|五
# >> +---------------+
# >> 先手の持駒：金 歩
# >> 手数＝9 ▲１二角(34) まで
# >> 
# >> 後手番
# >> 
