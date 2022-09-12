require "./setup"

xcontainer = Xcontainer.new
xcontainer.board.placement_from_preset("裸玉")

xcontainer.turn_info.handicap = false
info = Parser.parse("position #{xcontainer.to_short_sfen}")
puts info.to_ki2

xcontainer.turn_info.handicap = true
info = Parser.parse("position #{xcontainer.to_short_sfen}")
puts info.to_ki2

# >> 手合割：十九枚落ち
# >> 
# >> まで0手で後手の勝ち
# >> 手合割：十九枚落ち
# >> 
# >> まで0手で下手の勝ち
