# 盤面の読み取り
require "./example_helper"

Parser.board_parse(<<~EOT) # => {#<Bushido::Location:0x007fee97647ea8 @attributes={:key=>:black, :name=>"先手", :mark=>"▲", :reverse_mark=>"▼", :other_marks=>["b", "^"], :varrow=>" ", :angle=>0, :code=>0}>=>[{:piece=><Bushido::Piece:70331359357560 歩 pawn>, :point=>#<Bushido::Point:70331357608100 "１一">}], #<Bushido::Location:0x007fee97647de0 @attributes={:key=>:white, :name=>"後手", :mark=>"▽", :reverse_mark=>"△", :other_marks=>["w"], :varrow=>"v", :angle=>180, :code=>1}>=>[]}
+---+
| 歩|
+---+
EOT

Parser.board_parse(<<~EOT) # => {#<Bushido::Location:0x007fee97647ea8 @attributes={:key=>:black, :name=>"先手", :mark=>"▲", :reverse_mark=>"▼", :other_marks=>["b", "^"], :varrow=>" ", :angle=>0, :code=>0}>=>[], #<Bushido::Location:0x007fee97647de0 @attributes={:key=>:white, :name=>"後手", :mark=>"▽", :reverse_mark=>"△", :other_marks=>["w"], :varrow=>"v", :angle=>180, :code=>1}>=>[{:piece=><Bushido::Piece:70331359357180 桂 knight>, :point=>#<Bushido::Point:70331357543200 "２一">}, {:piece=><Bushido::Piece:70331359357260 香 lance>, :point=>#<Bushido::Point:70331357523300 "１一">}]}
+------+
|v桂v香|
| ・ ・|
+------+
EOT

Parser.board_parse(<<~EOT) # => {#<Bushido::Location:0x007fee97647ea8 @attributes={:key=>:black, :name=>"先手", :mark=>"▲", :reverse_mark=>"▼", :other_marks=>["b", "^"], :varrow=>" ", :angle=>0, :code=>0}>=>[{:piece=><Bushido::Piece:70331359357440 角 bishop>, :promoted=>true, :point=>#<Bushido::Point:70331357216580 "５一">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :promoted=>true, :point=>#<Bushido::Point:70331357002220 "４二">}, {:piece=><Bushido::Piece:70331359357080 銀 silver>, :promoted=>true, :point=>#<Bushido::Point:70331356919600 "６三">}, {:piece=><Bushido::Piece:70331359357080 銀 silver>, :point=>#<Bushido::Point:70331365055340 "４五">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :point=>#<Bushido::Point:70331364956800 "７六">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :point=>#<Bushido::Point:70331364922300 "８七">}, {:piece=><Bushido::Piece:70331359357080 銀 silver>, :point=>#<Bushido::Point:70331364902380 "７七">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :point=>#<Bushido::Point:70331364644220 "９八">}, {:piece=><Bushido::Piece:70331359356860 玉 king>, :point=>#<Bushido::Point:70331364628720 "７八">}, {:piece=><Bushido::Piece:70331359357260 香 lance>, :point=>#<Bushido::Point:70331364772740 "６八">}, {:piece=><Bushido::Piece:70331359357260 香 lance>, :point=>#<Bushido::Point:70331364711760 "１八">}, {:piece=><Bushido::Piece:70331359357260 香 lance>, :point=>#<Bushido::Point:70331364618520 "９九">}, {:piece=><Bushido::Piece:70331359357180 桂 knight>, :point=>#<Bushido::Point:70331356215640 "８九">}, {:piece=><Bushido::Piece:70331359357360 飛 rook>, :point=>#<Bushido::Point:70331360385940 "３九">}], #<Bushido::Location:0x007fee97647de0 @attributes={:key=>:white, :name=>"後手", :mark=>"▽", :reverse_mark=>"△", :other_marks=>["w"], :varrow=>"v", :angle=>180, :code=>1}>=>[{:piece=><Bushido::Piece:70331359357180 桂 knight>, :point=>#<Bushido::Point:70331357359960 "８一">}, {:piece=><Bushido::Piece:70331359357180 桂 knight>, :point=>#<Bushido::Point:70331357166320 "２一">}, {:piece=><Bushido::Piece:70331359357260 香 lance>, :point=>#<Bushido::Point:70331357116500 "１一">}, {:piece=><Bushido::Piece:70331359357360 飛 rook>, :point=>#<Bushido::Point:70331357035800 "９二">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :point=>#<Bushido::Point:70331356867500 "５三">}, {:piece=><Bushido::Piece:70331359356860 玉 king>, :point=>#<Bushido::Point:70331356835780 "３三">}, {:piece=><Bushido::Piece:70331359357180 桂 knight>, :point=>#<Bushido::Point:70331356546140 "３四">}, {:piece=><Bushido::Piece:70331359356960 金 gold>, :point=>#<Bushido::Point:70331356517460 "１四">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :point=>#<Bushido::Point:70331365081200 "８五">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :point=>#<Bushido::Point:70331365023540 "３五">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :point=>#<Bushido::Point:70331365015840 "２五">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :point=>#<Bushido::Point:70331365000920 "１五">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :point=>#<Bushido::Point:70331364971740 "９六">}, {:piece=><Bushido::Piece:70331359357440 角 bishop>, :point=>#<Bushido::Point:70331364950220 "６六">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :point=>#<Bushido::Point:70331364876100 "６七">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :promoted=>true, :point=>#<Bushido::Point:70331364855760 "５七">}]}
+---------------------------+
| ・v桂 ・ ・ 馬 ・ ・v桂v香|
|v飛 ・ ・ ・ ・ と ・ ・ ・|
| ・ ・ ・ 全v歩 ・v玉 ・ ・|
| ・ ・ ・ ・ ・ ・v桂 ・v金|
| ・v歩 ・ ・ ・ 銀v歩v歩v歩|
|v歩 ・ 歩v角 ・ ・ ・ ・ ・|
| ・ 歩 銀v歩vと ・ ・ ・ ・|
| 歩 ・ 玉 香 ・ ・ ・ ・ 香|
| 香 桂 ・ ・ ・ ・ 飛 ・ ・|
+---------------------------+
EOT
