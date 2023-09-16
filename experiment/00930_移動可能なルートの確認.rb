# 移動可能なルートの確認
require "./setup"

container = Container::Basic.new
player = container.player_at(:black)
player.soldier_create("５五馬")
player.soldiers.each do |soldier|
  soldier.move_list(container.board).each do |v|
    player.soldier_create("#{v.place}馬")
  end
end
puts container.board

container = Container::Basic.new
player = container.player_at(:black)
soldier = Soldier.from_str("▲５五馬")
soldier.move_list(container.board).each do |soldier|
  player.soldier_create("#{soldier.place}馬")
end
puts container.board
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | 馬 ・ ・ ・ ・ ・ ・ ・ 馬|一
# >> | ・ 馬 ・ ・ ・ ・ ・ 馬 ・|二
# >> | ・ ・ 馬 ・ ・ ・ 馬 ・ ・|三
# >> | ・ ・ ・ 馬 馬 馬 ・ ・ ・|四
# >> | ・ ・ ・ 馬 馬 馬 ・ ・ ・|五
# >> | ・ ・ ・ 馬 馬 馬 ・ ・ ・|六
# >> | ・ ・ 馬 ・ ・ ・ 馬 ・ ・|七
# >> | ・ 馬 ・ ・ ・ ・ ・ 馬 ・|八
# >> | 馬 ・ ・ ・ ・ ・ ・ ・ 馬|九
# >> +---------------------------+
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | 馬 ・ ・ ・ ・ ・ ・ ・ 馬|一
# >> | ・ 馬 ・ ・ ・ ・ ・ 馬 ・|二
# >> | ・ ・ 馬 ・ ・ ・ 馬 ・ ・|三
# >> | ・ ・ ・ 馬 馬 馬 ・ ・ ・|四
# >> | ・ ・ ・ 馬 ・ 馬 ・ ・ ・|五
# >> | ・ ・ ・ 馬 馬 馬 ・ ・ ・|六
# >> | ・ ・ 馬 ・ ・ ・ 馬 ・ ・|七
# >> | ・ 馬 ・ ・ ・ ・ ・ 馬 ・|八
# >> | 馬 ・ ・ ・ ・ ・ ・ ・ 馬|九
# >> +---------------------------+
