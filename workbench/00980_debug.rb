require "#{__dir__}/setup"

# info = Parser.parse("68S")
# # puts info.to_kif
# # puts info.to_ki2
# puts info.to_csa
# # puts info.to_sfen

info = Parser.parse("position sfen 9/4k4/9/9/9/9/PPPPPPPPP/1B2K2R1/LNSG1GSNL w - 3")
p info
p info.pi
puts info.to_kif
# >> * attributes
# >> |-------------------+--|
# >> | force_preset_info |  |
# >> |    force_location |  |
# >> |    force_handicap |  |
# >> |-------------------+--|
# >>
# >> * pi.header
# >>
# >>
# >> * pi.move_infos
# >>
# >>
# >> * @parser.pi.last_action_params
# >> #<Bioshogi::Parser::Pi:0x00007fd09c1931a0 @move_infos=[], @first_comments=[], @board_source=nil, @last_action_params=nil, @header=, @force_preset_info=nil, @force_location=nil, @force_handicap=nil, @player_piece_boxes={:black=>{}, :white=>{}}, @error_message=nil>
# >> 先手の備考：居飛車, 相居飛車
# >> 後手の備考：居飛車, 相居飛車
# >> 手合割：平手
# >> 手数----指手---------消費時間--
# >>    1 投了
# >> まで0手で後手の勝ち
