require "#{__dir__}/setup"

object = TurnInfo.new(handicap: true)
object                          # => #<駒落ち:0+0:△上手番>
object.turn_offset += 1
object                          # => #<駒落ち:0+1:▲下手番>

Parser.parse("６八銀").container.turn_info.turn_offset # => 1

info = Parser.parse("72 投了")
info.formatter.container.turn_info.turn_offset # => 0
info.formatter.container.turn_info.display_turn # => 0
info.formatter.container.turn_info.current_location.key # => :black
info.formatter.container.turn_info.inspect # => "#<平手:0+0:▲先手番>"
puts info.to_kif

# >> 先手の駒使用：歩0 銀0 金0 飛0 角0 玉0 桂0 香0 馬0 龍0 と0 圭0 全0 杏0
# >> 先手の玉移動：0回
# >> 先手のキル数：0キル
# >> 後手の駒使用：歩0 銀0 金0 飛0 角0 玉0 桂0 香0 馬0 龍0 と0 圭0 全0 杏0
# >> 後手の玉移動：0回
# >> 後手のキル数：0キル
# >> 総手数：0手
# >> 総キル数：0キル
# >> 結末：投了
# >> 手合割：平手
# >> 手数----指手---------消費時間--
# >>    1 投了
# >> まで0手で後手の勝ち
