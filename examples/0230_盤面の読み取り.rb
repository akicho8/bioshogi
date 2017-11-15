# 盤面の読み取り
require "./example_helper"

Parser.board_parse(<<~EOT) # => {#<Bushido::Location:0x007fee97647ea8 @attributes={:key=>:black, :name=>"先手", :mark=>"▲", :reverse_mark=>"▼", :other_marks=>["b", "^"], :varrow=>" ", :angle=>0, :code=>0}>=>[{:piece=><Bushido::Piece:70331359357560 歩 pawn>, :point=>#<Bushido::Point:70331357608100 "1一">}], #<Bushido::Location:0x007fee97647de0 @attributes={:key=>:white, :name=>"後手", :mark=>"▽", :reverse_mark=>"△", :other_marks=>["w"], :varrow=>"v", :angle=>180, :code=>1}>=>[]}
+---+
| 歩|
+---+
EOT

Parser.board_parse(<<~EOT) # => {#<Bushido::Location:0x007fee97647ea8 @attributes={:key=>:black, :name=>"先手", :mark=>"▲", :reverse_mark=>"▼", :other_marks=>["b", "^"], :varrow=>" ", :angle=>0, :code=>0}>=>[], #<Bushido::Location:0x007fee97647de0 @attributes={:key=>:white, :name=>"後手", :mark=>"▽", :reverse_mark=>"△", :other_marks=>["w"], :varrow=>"v", :angle=>180, :code=>1}>=>[{:piece=><Bushido::Piece:70331359357180 桂 knight>, :point=>#<Bushido::Point:70331357543200 "2一">}, {:piece=><Bushido::Piece:70331359357260 香 lance>, :point=>#<Bushido::Point:70331357523300 "1一">}]}
+------+
|v桂v香|
| ・ ・|
+------+
EOT

Parser.board_parse(<<~EOT) # => {#<Bushido::Location:0x007fee97647ea8 @attributes={:key=>:black, :name=>"先手", :mark=>"▲", :reverse_mark=>"▼", :other_marks=>["b", "^"], :varrow=>" ", :angle=>0, :code=>0}>=>[{:piece=><Bushido::Piece:70331359357440 角 bishop>, :promoted=>true, :point=>#<Bushido::Point:70331357216580 "5一">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :promoted=>true, :point=>#<Bushido::Point:70331357002220 "4二">}, {:piece=><Bushido::Piece:70331359357080 銀 silver>, :promoted=>true, :point=>#<Bushido::Point:70331356919600 "6三">}, {:piece=><Bushido::Piece:70331359357080 銀 silver>, :point=>#<Bushido::Point:70331365055340 "4五">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :point=>#<Bushido::Point:70331364956800 "7六">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :point=>#<Bushido::Point:70331364922300 "8七">}, {:piece=><Bushido::Piece:70331359357080 銀 silver>, :point=>#<Bushido::Point:70331364902380 "7七">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :point=>#<Bushido::Point:70331364644220 "9八">}, {:piece=><Bushido::Piece:70331359356860 玉 king>, :point=>#<Bushido::Point:70331364628720 "7八">}, {:piece=><Bushido::Piece:70331359357260 香 lance>, :point=>#<Bushido::Point:70331364772740 "6八">}, {:piece=><Bushido::Piece:70331359357260 香 lance>, :point=>#<Bushido::Point:70331364711760 "1八">}, {:piece=><Bushido::Piece:70331359357260 香 lance>, :point=>#<Bushido::Point:70331364618520 "9九">}, {:piece=><Bushido::Piece:70331359357180 桂 knight>, :point=>#<Bushido::Point:70331356215640 "8九">}, {:piece=><Bushido::Piece:70331359357360 飛 rook>, :point=>#<Bushido::Point:70331360385940 "3九">}], #<Bushido::Location:0x007fee97647de0 @attributes={:key=>:white, :name=>"後手", :mark=>"▽", :reverse_mark=>"△", :other_marks=>["w"], :varrow=>"v", :angle=>180, :code=>1}>=>[{:piece=><Bushido::Piece:70331359357180 桂 knight>, :point=>#<Bushido::Point:70331357359960 "8一">}, {:piece=><Bushido::Piece:70331359357180 桂 knight>, :point=>#<Bushido::Point:70331357166320 "2一">}, {:piece=><Bushido::Piece:70331359357260 香 lance>, :point=>#<Bushido::Point:70331357116500 "1一">}, {:piece=><Bushido::Piece:70331359357360 飛 rook>, :point=>#<Bushido::Point:70331357035800 "9二">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :point=>#<Bushido::Point:70331356867500 "5三">}, {:piece=><Bushido::Piece:70331359356860 玉 king>, :point=>#<Bushido::Point:70331356835780 "3三">}, {:piece=><Bushido::Piece:70331359357180 桂 knight>, :point=>#<Bushido::Point:70331356546140 "3四">}, {:piece=><Bushido::Piece:70331359356960 金 gold>, :point=>#<Bushido::Point:70331356517460 "1四">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :point=>#<Bushido::Point:70331365081200 "8五">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :point=>#<Bushido::Point:70331365023540 "3五">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :point=>#<Bushido::Point:70331365015840 "2五">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :point=>#<Bushido::Point:70331365000920 "1五">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :point=>#<Bushido::Point:70331364971740 "9六">}, {:piece=><Bushido::Piece:70331359357440 角 bishop>, :point=>#<Bushido::Point:70331364950220 "6六">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :point=>#<Bushido::Point:70331364876100 "6七">}, {:piece=><Bushido::Piece:70331359357560 歩 pawn>, :promoted=>true, :point=>#<Bushido::Point:70331364855760 "5七">}]}
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
