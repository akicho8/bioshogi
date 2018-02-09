# 移動可能なルートの確認
require "./example_helper"

mediator = Mediator.new
player = mediator.player_at(:black)
player.battlers_create("５五馬", from_stand: false)
player.battlers.each do |battler|
  battler.moved_list(mediator.board).each do |v|
    player.battlers_create("#{v.point}馬", from_stand: false)
  end
end
puts mediator.board

mediator = Mediator.new
player = mediator.player_at(:black)
soldier = Soldier.from_str("▲５五馬")
soldier.moved_list(mediator.board).each do |soldier|
  player.battlers_create("#{soldier.point}馬", from_stand: false)
end
puts mediator.board
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
