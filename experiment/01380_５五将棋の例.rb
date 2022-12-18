require "./setup"

Board.dimensiton_change([5, 5])
container = Container.create
soldiers = ["５五玉", "４五金", "３五銀", "２五角", "１五飛", "５四歩"].collect { |e| Soldier.from_str(e, location: :black) }
container.players.each do |player|
  if player.location.key == :white
    s = soldiers.collect(&:flip)
  else
    s = soldiers
  end
  player.soldier_create(s)
end
container.piece_box_clear
p container
container.execute("２四銀")
container.execute("４二銀")
container.execute("３四角")
container.execute("３二角")
container.execute("２三銀")
container.execute("４三銀")
container.execute("１二銀")
container.execute("同金")
container.execute("同角")
p container
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
