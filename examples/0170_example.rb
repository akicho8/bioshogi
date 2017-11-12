# 盤面の読み取り
require "./example_helper"

board = <<-EOT
+------+
|v桂v香|
| ・ ・|
+------+
EOT
BaseFormat.board_parse(board) # => {#<Bushido::Location:0x007fe643b64028 @attributes={:key=>:black, :name=>"先手", :mark=>"▲", :reverse_mark=>"▼", :other_marks=>["b", "^"], :varrow=>" ", :angle=>0, :code=>0}>=>[], #<Bushido::Location:0x007fe643b5ff28 @attributes={:key=>:white, :name=>"後手", :mark=>"▽", :reverse_mark=>"△", :other_marks=>["w"], :varrow=>"v", :angle=>180, :code=>1}>=>[{:piece=><Bushido::Piece:70313477503500 桂 knight>, :point=>#<Bushido::Point:70313477881480 "2一">}, {:piece=><Bushido::Piece:70313477503600 香 lance>, :point=>#<Bushido::Point:70313477877100 "1一">}]}

board = <<-EOT
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
BaseFormat.board_parse(board) # => {#<Bushido::Location:0x007fe643b64028 @attributes={:key=>:black, :name=>"先手", :mark=>"▲", :reverse_mark=>"▼", :other_marks=>["b", "^"], :varrow=>" ", :angle=>0, :code=>0}>=>[{:piece=><Bushido::Piece:70313477503780 角 bishop>, :promoted=>true, :point=>#<Bushido::Point:70313484392860 "5一">}, {:piece=><Bushido::Piece:70313477503900 歩 pawn>, :promoted=>true, :point=>#<Bushido::Point:70313482077800 "4二">}, {:piece=><Bushido::Piece:70313477503420 銀 silver>, :promoted=>true, :point=>#<Bushido::Point:70313477828120 "6三">}, {:piece=><Bushido::Piece:70313477503420 銀 silver>, :point=>#<Bushido::Point:70313477783320 "4五">}, {:piece=><Bushido::Piece:70313477503900 歩 pawn>, :point=>#<Bushido::Point:70313477760660 "7六">}, {:piece=><Bushido::Piece:70313477503900 歩 pawn>, :point=>#<Bushido::Point:70313477747600 "8七">}, {:piece=><Bushido::Piece:70313477503420 銀 silver>, :point=>#<Bushido::Point:70313477745900 "7七">}, {:piece=><Bushido::Piece:70313477503900 歩 pawn>, :point=>#<Bushido::Point:70313477715840 "9八">}, {:piece=><Bushido::Piece:70313477503240 玉 king>, :point=>#<Bushido::Point:70313477713340 "7八">}, {:piece=><Bushido::Piece:70313477503600 香 lance>, :point=>#<Bushido::Point:70313477710460 "6八">}, {:piece=><Bushido::Piece:70313477503600 香 lance>, :point=>#<Bushido::Point:70313477700080 "1八">}, {:piece=><Bushido::Piece:70313477503600 香 lance>, :point=>#<Bushido::Point:70313477697280 "9九">}, {:piece=><Bushido::Piece:70313477503500 桂 knight>, :point=>#<Bushido::Point:70313477694640 "8九">}, {:piece=><Bushido::Piece:70313477503700 飛 rook>, :point=>#<Bushido::Point:70313477683720 "3九">}], #<Bushido::Location:0x007fe643b5ff28 @attributes={:key=>:white, :name=>"後手", :mark=>"▽", :reverse_mark=>"△", :other_marks=>["w"], :varrow=>"v", :angle=>180, :code=>1}>=>[{:piece=><Bushido::Piece:70313477503500 桂 knight>, :point=>#<Bushido::Point:70313477842620 "8一">}, {:piece=><Bushido::Piece:70313477503500 桂 knight>, :point=>#<Bushido::Point:70313484389080 "2一">}, {:piece=><Bushido::Piece:70313477503600 香 lance>, :point=>#<Bushido::Point:70313482084100 "1一">}, {:piece=><Bushido::Piece:70313477503700 飛 rook>, :point=>#<Bushido::Point:70313482080820 "9二">}, {:piece=><Bushido::Piece:70313477503900 歩 pawn>, :point=>#<Bushido::Point:70313477815880 "5三">}, {:piece=><Bushido::Piece:70313477503240 玉 king>, :point=>#<Bushido::Point:70313477813340 "3三">}, {:piece=><Bushido::Piece:70313477503500 桂 knight>, :point=>#<Bushido::Point:70313477809740 "3四">}, {:piece=><Bushido::Piece:70313477503320 金 gold>, :point=>#<Bushido::Point:70313477799160 "1四">}, {:piece=><Bushido::Piece:70313477503900 歩 pawn>, :point=>#<Bushido::Point:70313477794560 "8五">}, {:piece=><Bushido::Piece:70313477503900 歩 pawn>, :point=>#<Bushido::Point:70313477780660 "3五">}, {:piece=><Bushido::Piece:70313477503900 歩 pawn>, :point=>#<Bushido::Point:70313477778620 "2五">}, {:piece=><Bushido::Piece:70313477503900 歩 pawn>, :point=>#<Bushido::Point:70313477776740 "1五">}, {:piece=><Bushido::Piece:70313477503900 歩 pawn>, :point=>#<Bushido::Point:70313477766140 "9六">}, {:piece=><Bushido::Piece:70313477503780 角 bishop>, :point=>#<Bushido::Point:70313477750460 "6六">}, {:piece=><Bushido::Piece:70313477503900 歩 pawn>, :point=>#<Bushido::Point:70313477742980 "6七">}, {:piece=><Bushido::Piece:70313477503900 歩 pawn>, :promoted=>true, :point=>#<Bushido::Point:70313477732240 "5七">}]}
