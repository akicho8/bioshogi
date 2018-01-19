require "./example_helper"

info = Parser.parse(<<~EOT)
V2.2
N+小池重明
N-加藤一二三
$EVENT:その他の棋戦
$SITE:null
$START_TIME:1982/03/03 9:00:00
$OPENING:中飛車
P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
P2 * -HI *  *  *  *  * -KA * 
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  * 
P5 *  *  *  *  *  *  *  *  * 
P6 *  *  *  *  *  *  *  *  * 
P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
P8 * +KA *  *  *  *  * +HI * 
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
+
-8384FU
+7776FU
-7162GI
+5756FU
-8485FU
+8877KA
-5354FU
+2858HI
-6253GI
+7968GI
-5142OU
+5948OU
-3132GI
+4838OU
-4344FU
+5655FU
-3243GI
+5554FU
-4354GI
+6857GI
-5465GI
+5756GI
-6576GI
+5655GI
-7667NG
+0054FU
-5362GI
+5856HI
-6777NG
+8977KE
-0034KA
+5666HI
-0052FU
+6979KI
-8284HI
+5544GI
-8474HI
+0078FU
-7454HI
+0043GI
-3443KA
+4443NG
-4243OU
+0076KA
-5253FU
+7968KI
-4332OU
+6858KI
-0043FU
+7654KA
-5354FU
+8786FU
-0079KA
+8685FU
-0082FU
+6686HI
-7935UM
+8584FU
-0072GI
+8689HI
-3545UM
+0067FU
-7374FU
+9796FU
-4556UM
+8986HI
-5655UM
+9695FU
-5564UM
+8689HI
-7475FU
+7785KE
-5455FU
+8593NK
-8193KE
+9594FU
-0098FU
+9998KY
-6465UM
+8986HI
-6598UM
+9493TO
-9193KY
+0091HI
-9865UM
+9193RY
-5556FU
+5848KI
-0092KY
+9382RY
-0081FU
+0077KE
-6574UM
+8291RY
-0082GI
+9182RY
-8182FU
+0065GI
-7496UM
+8656HI
-9678UM
+7785KE
-7867UM
+0073FU
-7281GI
+0093FU
-6364FU
+0068FU
-6785UM
+9392TO
-8192GI
+7372TO
-6172KI
+6554GI
-0042KE
+5453NG
-0054FU
+5362NG
-7262KI
+0026KY
-0069HI
+0025KY
-0031KE
+5646HI
-0034GI
+3736FU
-6253KI
+2937KE
-4344FU
+4656HI
-2324FU
+2524KY
-0023FU
+3635FU
-3435GI
+2423NY
-3123KE
+2623NY
-3223OU
+0036FU
-3524GI
+5659HI
-6968RY
+1716FU
-0034KY
+0028KE
-4445FU
+5958HI
-6877RY
+2726FU
-1314FU
+2625FU
-2413GI
+3745KE
-5344KI
+0046GI
-0026FU
+4553NK
-0045KY
+4657GI
-8574UM
+0065FU
-7465UM
+0056FU
-5455FU
+4837KI
-5556FU
+5748GI
-0046FU
+3746KI
-4546KY
%TORYO
EOT

puts info.to_kif
# ~> /Users/ikeda/src/bushido/lib/bushido/mediator.rb:212:in `block in execute': 【反則】先手番で後手が着手しました : -8384FU (Bushido::DifferentTurnError)
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/mediator.rb:203:in `each'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/mediator.rb:203:in `execute'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:377:in `block in mediator_run_all'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:367:in `each'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:367:in `mediator_run_all'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:337:in `block in mediator'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:335:in `tap'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:335:in `mediator'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:325:in `mediator_run'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:228:in `to_kif'
# ~> 	from -:195:in `<main>'
