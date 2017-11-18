require "./example_helper"

def assert_equal(a, b)
  if a == b
    puts "OK"
  else
    puts "ERROR"
  end
end

files = Pathname.glob("../resources/竜王戦_ki2/*.ki2")
files.each do |file|
  puts file

  info = Parser.parse_file(file)
  kif_str = info.to_kif
  ki2_str = info.to_ki2
  csa_str = info.to_csa

  # v = Parser.parse(kif_str)
  # assert_equal(v.to_kif, kif_str)
  # assert_equal(v.to_ki2, ki2_str)
  # assert_equal(v.to_csa, csa_str)
  #
  # v = Parser.parse(ki2_str)
  # assert_equal(v.to_kif, kif_str)
  # assert_equal(v.to_ki2, ki2_str)
  # assert_equal(v.to_csa, csa_str)

  puts csa_str

  v = Parser.parse(csa_str)
  v.to_kif

  # assert_equal(v.to_kif, kif_str)
  # assert_equal(v.to_ki2, ki2_str)
  # assert_equal(v.to_csa, csa_str)

  break
end
# ~> /Users/ikeda/src/bushido/lib/bushido/player.rb:345:in `block in put_on_with_valid': １二桂はそれ以上動かせないので反則です (Bushido::NotPutInPlaceNotBeMoved)
# ~>   ９ ８ ７ ６ ５ ４ ３ ２ １
# ~> +---------------------------+
# ~> |v香v桂v角 ・ ・ ・ ・ ・ ・|一
# ~> |v飛 ・ ・ ・ ・ ・ ・ ・ ・|二
# ~> | ・ 歩 ・ ・ ・v金v金 ・ ・|三
# ~> |v歩 ・ ・v歩v歩v歩v歩 ・v玉|四
# ~> | ・ 銀 ・ ・ ・ 歩 ・v桂v歩|五
# ~> | 歩 ・ 歩 歩 銀 ・ 歩 飛 ・|六
# ~> | ・ 玉 ・ 銀 ・ 金 ・ ・ ・|七
# ~> | ・ ・ ・ 角 ・ ・ ・ ・ ・|八
# ~> | 香 ・ ・ ・ ・ ・ ・ ・ 香|九
# ~> +---------------------------+
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/player.rb:344:in `each'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/player.rb:344:in `put_on_with_valid'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/player.rb:124:in `move_to'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/runner.rb:112:in `execute'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/player.rb:137:in `execute'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/mediator.rb:136:in `block in execute'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/mediator.rb:132:in `each'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/mediator.rb:132:in `execute'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:304:in `block (2 levels) in mediator'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:303:in `each'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:303:in `block in mediator'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:273:in `tap'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:273:in `mediator'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:223:in `to_kif'
# ~> 	from -:33:in `block in <main>'
# ~> 	from -:12:in `each'
# ~> 	from -:12:in `<main>'
# >> ../resources/竜王戦_ki2/九段戦1950-01 大山板谷-2.ki2
# >> V2.2
# >> N+大山康晴八段
# >> N-板谷四郎八段
# >> $EVENT:第01期九段戦
# >> $SITE:静岡県熱海温泉・和楽荘
# >> $START_TIME:1950/07/06 10:00:00
# >> $END_TIME:1950/07/07 03:20:00
# >> $OPENING:矢倉
# >> P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
# >> P2 * -HI *  *  *  *  * -KA * 
# >> P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
# >> P4 *  *  *  *  *  *  *  *  * 
# >> P5 *  *  *  *  *  *  *  *  * 
# >> P6 *  *  *  *  *  *  *  *  * 
# >> P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
# >> P8 * +KA *  *  *  *  * +HI * 
# >> P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
# >> +
# >> +7776FU
# >> -8384FU
# >> +7978GI
# >> -3334FU
# >> +7877GI
# >> -8485FU
# >> +2726FU
# >> -3142GI
# >> +6978KI
# >> -4132KI
# >> +3948GI
# >> -7162GI
# >> +5756FU
# >> -5354FU
# >> +5969OU
# >> -5141OU
# >> +2625FU
# >> -4233GI
# >> +4857GI
# >> -6253GI
# >> +3736FU
# >> -6152KI
# >> +4958KI
# >> -7374FU
# >> +4746FU
# >> -4344FU
# >> +2937KE
# >> -5364GI
# >> +6766FU
# >> -5243KI
# >> +5847KI
# >> -2231KA
# >> +5768GI
# >> -7475FU
# >> +6867GI
# >> -7576FU
# >> +6776GI
# >> -0075FU
# >> +7667GI
# >> -6473GI
# >> +2858HI
# >> -7374GI
# >> +5655FU
# >> -5455FU
# >> +5855HI
# >> -3142KA
# >> +5558HI
# >> -4131OU
# >> +8879KA
# >> -0054FU
# >> +7968KA
# >> -3122OU
# >> +6979OU
# >> -9394FU
# >> +1716FU
# >> -1314FU
# >> +6756GI
# >> -7576FU
# >> +7776GI
# >> -7475GI
# >> +7675GI
# >> -4275KA
# >> +7877KI
# >> -7584KA
# >> +0076GI
# >> -6364FU
# >> +7978OU
# >> -8272HI
# >> +0075FU
# >> -8493KA
# >> +9796FU
# >> -0084GI
# >> +7667GI
# >> -8475GI
# >> +0076FU
# >> -7584GI
# >> +4645FU
# >> -8586FU
# >> +8786FU
# >> -0085FU
# >> +2524FU
# >> -2324FU
# >> +0025FU
# >> -8586FU
# >> +2524FU
# >> -8485GI
# >> +5828HI
# >> -0026FU
# >> +2826HI
# >> -9371KA
# >> +2628HI
# >> -0026FU
# >> +0084FU
# >> -7282HI
# >> +1615FU
# >> -1415FU
# >> +3725KE
# >> -8284HI
# >> +0012FU
# >> -1112KY
# >> +0013FU
# >> -2113KE
# >> +2533NK
# >> -2233OU
# >> +8997KE
# >> -0075KE
# >> +9785KE
# >> -8687TO
# >> +7787KI
# >> -7587NK
# >> +7887OU
# >> -0086FU
# >> +6886KA
# >> -8485HI
# >> +0074GI
# >> -8584HI
# >> +0085GI
# >> -8482HI
# >> +0083FU
# >> -8292HI
# >> +0014FU
# >> -1325KE
# >> +2826HI
# >> -3324OU
# >> +8668KA
# >> -2414OU
# >> +0024KE
# >> -3233KI
# >> +2412NK
# >> -0024FU
# >> +1213NK
# >> -1413OU
# >> +2625HI
# >> -0014KI
# >> +2528HI
# >> -1323OU
# >> +8382TO
# >> -9282HI
# >> +0084KY
# >> -8212HI
# >> +8481NY
# >> -7153KA
# >> +7463NG
# >> -0055KE
# >> +5655GI
# >> -5455FU
# >> +0026KE
# >> -1425KI
# >> +0037KE
# >> -2526KI
# >> +2826HI
# >> -0086FU
# >> +8786OU
# >> -0084FU
# >> +8584GI
# >> -0085FU
# >> +8685OU
# >> -0093KE
# >> +8493NG
# >> -9193KY
# >> +0025FU
# >> %TORYO
