require "./setup"

mediator = Mediator.new
mediator.board.placement_from_hash("裸玉")

mediator.turn_info.handicap = false
info = Parser.parse("position #{mediator.to_snapshot_sfen}")
puts info.to_ki2

mediator.turn_info.handicap = true
info = Parser.parse("position #{mediator.to_snapshot_sfen}")
puts info.to_ki2

# >> 手合割：十九枚落ち
# >> 
# >> まで0手で後手の勝ち
# >> 手合割：十九枚落ち
# >> 
# >> まで0手で下手の勝ち
