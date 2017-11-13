# 盤面の読み取り
require "./example_helper"

BaseFormat.board_parse(<<~EOT) # => {#<Bushido::Location:0x007fa0408c3628 @attributes={:key=>:black, :name=>"先手", :mark=>"▲", :reverse_mark=>"▼", :other_marks=>["b", "^"], :varrow=>" ", :angle=>0, :code=>0}>=>[{:piece=><Bushido::Piece:70163131487940 歩 pawn>, :point=>#<Bushido::Point:70163120336680 "1一">}], #<Bushido::Location:0x007fa0408c3560 @attributes={:key=>:white, :name=>"後手", :mark=>"▽", :reverse_mark=>"△", :other_marks=>["w"], :varrow=>"v", :angle=>180, :code=>1}>=>[]}
+---+
| 歩|
+---+
EOT

BaseFormat.board_parse(<<~EOT) # => {#<Bushido::Location:0x007fa0408c3628 @attributes={:key=>:black, :name=>"先手", :mark=>"▲", :reverse_mark=>"▼", :other_marks=>["b", "^"], :varrow=>" ", :angle=>0, :code=>0}>=>[], #<Bushido::Location:0x007fa0408c3560 @attributes={:key=>:white, :name=>"後手", :mark=>"▽", :reverse_mark=>"△", :other_marks=>["w"], :varrow=>"v", :angle=>180, :code=>1}>=>[{:piece=><Bushido::Piece:70163131487600 桂 knight>, :point=>#<Bushido::Point:70163120308020 "2一">}, {:piece=><Bushido::Piece:70163131487680 香 lance>, :point=>#<Bushido::Point:70163120304580 "1一">}]}
+------+
|v桂v香|
| ・ ・|
+------+
EOT

BaseFormat.board_parse(<<~EOT) # => {#<Bushido::Location:0x007fa0408c3628 @attributes={:key=>:black, :name=>"先手", :mark=>"▲", :reverse_mark=>"▼", :other_marks=>["b", "^"], :varrow=>" ", :angle=>0, :code=>0}>=>[{:piece=><Bushido::Piece:70163131487840 角 bishop>, :promoted=>true, :point=>#<Bushido::Point:70163131533900 "5一">}, {:piece=><Bushido::Piece:70163131487940 歩 pawn>, :promoted=>true, :point=>#<Bushido::Point:70163127308260 "4二">}, {:piece=><Bushido::Piece:70163131487520 銀 silver>, :promoted=>true, :point=>#<Bushido::Point:70163127304600 "6三">}, {:piece=><Bushido::Piece:70163131487520 銀 silver>, :point=>#<Bushido::Point:70163127260800 "4五">}, {:piece=><Bushido::Piece:70163131487940 歩 pawn>, :point=>#<Bushido::Point:70163127229480 "7六">}, {:piece=><Bushido::Piece:70163131487940 歩 pawn>, :point=>#<Bushido::Point:70163120272240 "8七">}, {:piece=><Bushido::Piece:70163131487520 銀 silver>, :point=>#<Bushido::Point:70163120270340 "7七">}, {:piece=><Bushido::Piece:70163131487940 歩 pawn>, :point=>#<Bushido::Point:70163120253460 "9八">}, {:piece=><Bushido::Piece:70163131487340 玉 king>, :point=>#<Bushido::Point:70163120251380 "7八">}, {:piece=><Bushido::Piece:70163131487680 香 lance>, :point=>#<Bushido::Point:70163124008380 "6八">}, {:piece=><Bushido::Piece:70163131487680 香 lance>, :point=>#<Bushido::Point:70163124004940 "1八">}, {:piece=><Bushido::Piece:70163131487680 香 lance>, :point=>#<Bushido::Point:70163123994060 "9九">}, {:piece=><Bushido::Piece:70163131487600 桂 knight>, :point=>#<Bushido::Point:70163123991820 "8九">}, {:piece=><Bushido::Piece:70163131487760 飛 rook>, :point=>#<Bushido::Point:70163123988200 "3九">}], #<Bushido::Location:0x007fa0408c3560 @attributes={:key=>:white, :name=>"後手", :mark=>"▽", :reverse_mark=>"△", :other_marks=>["w"], :varrow=>"v", :angle=>180, :code=>1}>=>[{:piece=><Bushido::Piece:70163131487600 桂 knight>, :point=>#<Bushido::Point:70163131536360 "8一">}, {:piece=><Bushido::Piece:70163131487600 桂 knight>, :point=>#<Bushido::Point:70163127325700 "2一">}, {:piece=><Bushido::Piece:70163131487680 香 lance>, :point=>#<Bushido::Point:70163127322000 "1一">}, {:piece=><Bushido::Piece:70163131487760 飛 rook>, :point=>#<Bushido::Point:70163127310960 "9二">}, {:piece=><Bushido::Piece:70163131487940 歩 pawn>, :point=>#<Bushido::Point:70163127292260 "5三">}, {:piece=><Bushido::Piece:70163131487340 玉 king>, :point=>#<Bushido::Point:70163127289660 "3三">}, {:piece=><Bushido::Piece:70163131487600 桂 knight>, :point=>#<Bushido::Point:70163127276280 "3四">}, {:piece=><Bushido::Piece:70163131487440 金 gold>, :point=>#<Bushido::Point:70163127273880 "1四">}, {:piece=><Bushido::Piece:70163131487940 歩 pawn>, :point=>#<Bushido::Point:70163127262700 "8五">}, {:piece=><Bushido::Piece:70163131487940 歩 pawn>, :point=>#<Bushido::Point:70163127246360 "3五">}, {:piece=><Bushido::Piece:70163131487940 歩 pawn>, :point=>#<Bushido::Point:70163127244400 "2五">}, {:piece=><Bushido::Piece:70163131487940 歩 pawn>, :point=>#<Bushido::Point:70163127242360 "1五">}, {:piece=><Bushido::Piece:70163131487940 歩 pawn>, :point=>#<Bushido::Point:70163127239860 "9六">}, {:piece=><Bushido::Piece:70163131487840 角 bishop>, :point=>#<Bushido::Point:70163127226580 "6六">}, {:piece=><Bushido::Piece:70163131487940 歩 pawn>, :point=>#<Bushido::Point:70163120267360 "6七">}, {:piece=><Bushido::Piece:70163131487940 歩 pawn>, :promoted=>true, :point=>#<Bushido::Point:70163120257280 "5七">}]}
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
