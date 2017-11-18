require "./example_helper"

csa_body = Pathname("katomomo.csa").read.strip

a = Parser.parse_file("katomomo.kif")
b = Parser.parse_file("katomomo.ki2")
c = Parser.parse_file("katomomo.csa")
a.to_kif == b.to_kif            # => 
a.to_ki2 == b.to_ki2            # => 
a.to_csa == b.to_csa            # => 

info = Parser.parse_file("katomomo.kif")
puts "-" * 80
puts info.to_ki2
puts "-" * 80
puts info.to_kif
puts "-" * 80
puts info.to_csa

info = Parser.parse_file("katomomo.ki2")
puts "-" * 80
puts info.to_ki2
puts "-" * 80
puts info.to_kif
puts "-" * 80
puts info.to_csa

info = Parser.parse_file("katomomo.csa")
puts "-" * 80
puts info.to_ki2
puts "-" * 80
puts info.to_kif
puts "-" * 80
puts info.to_csa

# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/memory_record-0.0.6/lib/memory_record/memory_record.rb:126:in `fetch': Bushido::StaticBoardInfo.fetch("平手") does not match anything (KeyError)
# ~> keys: [:カニ囲い, :金矢倉, :銀矢倉, :片矢倉, :総矢倉, :矢倉穴熊, :菊水穴熊, :銀立ち矢倉, :菱矢倉, :雁木囲い, :ボナンザ囲い, :美濃囲い, :高美濃囲い, :銀冠, :銀美濃, :ダイヤモンド美濃, :木村美濃, :片美濃囲い, :ちょんまげ美濃, :左美濃, :天守閣美濃, :四枚美濃, :舟囲い, :居飛車穴熊, :松尾流穴熊, :銀冠穴熊, :ビッグ４, :箱入り娘, :ミレニアム囲い, :振り飛車穴熊, :右矢倉, :金無双, :中住まい, :中原玉, :アヒル囲い, :いちご囲い, :３七銀戦法, :森下システム, :雀刺し, :米長流急戦矢倉]
# ~> codes: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39]
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/utils.rb:28:in `location_soldiers'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/utils.rb:76:in `block in board_reset_args'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/utils.rb:75:in `each'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/utils.rb:75:in `inject'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/utils.rb:75:in `board_reset_args'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/utils.rb:80:in `board_reset_args'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/mediator.rb:92:in `board_reset'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:300:in `block in mediator'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:273:in `tap'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:273:in `mediator'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:223:in `to_kif'
# ~> 	from -:8:in `<main>'
