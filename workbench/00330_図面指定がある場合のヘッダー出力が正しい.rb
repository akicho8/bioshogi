require "#{__dir__}/setup"

container = Container::Basic.new
container.board.placement_from_preset("十九枚落ち")

container.turn_info.handicap = false
info = Parser.parse("position #{container.to_short_sfen}")
puts info.to_ki2

container.turn_info.handicap = true
info = Parser.parse("position #{container.to_short_sfen}")
puts info.to_ki2

# >> 手合割：十九枚落ち
# >>
# >> まで0手で後手の勝ち
# >> 手合割：十九枚落ち
# >>
# >> まで0手で下手の勝ち
