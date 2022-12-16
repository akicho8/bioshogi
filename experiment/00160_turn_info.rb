require "./setup"

object = TurnInfo.new(handicap: true)
object                          # => #<0+0:△上手番>
object.counter += 1
object                          # => #<0+1:▲下手番>

Parser.parse("６八銀").xcontainer.turn_info.turn_offset # => 1

info = Parser.parse("72 投了")
info.formatter.xcontainer.turn_info.turn_offset # => 0
info.formatter.xcontainer.turn_info.display_turn # => 71
info.formatter.xcontainer.turn_info.current_location.key # => :white
info.formatter.xcontainer.turn_info.inspect # => "#<71+0:△後手番>"
puts info.to_kif

# >> 先手の備考：居飛車, 相居飛車, 居玉, 相居玉
# >> 後手の備考：居飛車, 相居飛車, 居玉, 相居玉
# >> 手合割：平手
# >> 手数----指手---------消費時間--
# >>   72 投了
# >> まで0手で先手の勝ち
