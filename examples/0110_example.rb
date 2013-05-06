# -*- coding: utf-8 -*-
# 移動可能なルートの確認

require "./example_helper"

mediator = Mediator.new
player = mediator.player_at(:black)
player.initial_soldiers("５五馬", from_piece: false)
player.soldiers.first.moveable_points.each{|v|
  player.initial_soldiers("#{v[:point]}馬", from_piece: false)
}
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
