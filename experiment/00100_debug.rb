require "./example_helper"

# info = Parser.parse("
# 後手の持駒：銀 歩三
#   ９ ８ ７ ６ ５ ４ ３ ２ １
# +---------------------------+
# |v香v飛 ・ ・ ・ ・v玉v桂v香|一
# | ・ ・ ・v金 ・ ・v金v銀 ・|二
# | ・ ・ ・ ・v歩v歩 歩 ・ ・|三
# |v歩 ・ ・ ・ ・v角 桂v歩v歩|四
# | ・ ・v歩 銀v銀 桂 ・ ・ ・|五
# | 歩 歩 歩 歩 ・ 歩 ・ ・ 歩|六
# | ・ ・ 桂 ・ 歩 ・ 金 ・ ・|七
# | ・ ・ 金 ・ ・ ・ ・ ・ ・|八
# | 香 ・ 玉 ・ ・ ・ ・ 飛 香|九
# +---------------------------+
# 先手の持駒：角 歩
# 手数＝71 まで
# 
# 後手番
# ")
# puts info.to_kif

info = Parser.parse("72 投了")
info.mediator.turn_info.current_location.key # => :white
info.mediator.turn_info.current_location.key # => :white
info.mediator.turn_info.inspect # => "#<71+0:△後手番>"
puts info.to_kif

# >> 先手の備考：居飛車, 相居飛車, 居玉, 相居玉
# >> 後手の備考：居飛車, 相居飛車, 居玉, 相居玉
# >> 手合割：平手
# >> 手数----指手---------消費時間--
# >>   72 投了
# >> まで0手で先手の勝ち
