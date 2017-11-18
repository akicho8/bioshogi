# 盤面の読み取り
require "./example_helper"

Parser.board_parse(<<~EOT) # => {#<Bushido::Location:0x007facd8470f90 @attributes={:key=>:black, :name=>"先手", :mark=>"▲", :reverse_mark=>"▼", :other_marks=>["b", "^"], :varrow=>" ", :angle=>0, :csa_sign=>"+", :code=>0}>=>[{:piece=><Bushido::Piece:70190169742900 歩 pawn>, :point=>#<Bushido::Point:70190173468700 "１一">}], #<Bushido::Location:0x007facd8470e00 @attributes={:key=>:white, :name=>"後手", :mark=>"▽", :reverse_mark=>"△", :other_marks=>["w"], :varrow=>"v", :angle=>180, :csa_sign=>"-", :code=>1}>=>[]}
+---+
| 歩|
+---+
EOT

Parser.board_parse(<<~EOT) # => {#<Bushido::Location:0x007facd8470f90 @attributes={:key=>:black, :name=>"先手", :mark=>"▲", :reverse_mark=>"▼", :other_marks=>["b", "^"], :varrow=>" ", :angle=>0, :csa_sign=>"+", :code=>0}>=>[], #<Bushido::Location:0x007facd8470e00 @attributes={:key=>:white, :name=>"後手", :mark=>"▽", :reverse_mark=>"△", :other_marks=>["w"], :varrow=>"v", :angle=>180, :csa_sign=>"-", :code=>1}>=>[{:piece=><Bushido::Piece:70190169743300 桂 knight>, :point=>#<Bushido::Point:70190173451340 "２一">}, {:piece=><Bushido::Piece:70190169743180 香 lance>, :point=>#<Bushido::Point:70190173449260 "１一">}]}
+------+
|v桂v香|
| ・ ・|
+------+
EOT

Parser.board_parse(<<~EOT) # => {#<Bushido::Location:0x007facd8470f90 @attributes={:key=>:black, :name=>"先手", :mark=>"▲", :reverse_mark=>"▼", :other_marks=>["b", "^"], :varrow=>" ", :angle=>0, :csa_sign=>"+", :code=>0}>=>[{:piece=><Bushido::Piece:70190169743080 角 bishop>, :promoted=>true, :point=>#<Bushido::Point:70190169939460 "５一">}, {:piece=><Bushido::Piece:70190169742900 歩 pawn>, :promoted=>true, :point=>#<Bushido::Point:70190169920340 "４二">}, {:piece=><Bushido::Piece:70190169751600 銀 silver>, :promoted=>true, :point=>#<Bushido::Point:70190169907080 "６三">}, {:piece=><Bushido::Piece:70190169751600 銀 silver>, :point=>#<Bushido::Point:70190169882800 "４五">}, {:piece=><Bushido::Piece:70190169742900 歩 pawn>, :point=>#<Bushido::Point:70190169853540 "７六">}, {:piece=><Bushido::Piece:70190169742900 歩 pawn>, :point=>#<Bushido::Point:70190173414640 "８七">}, {:piece=><Bushido::Piece:70190169751600 銀 silver>, :point=>#<Bushido::Point:70190169840760 "７七">}, {:piece=><Bushido::Piece:70190169742900 歩 pawn>, :point=>#<Bushido::Point:70190169823480 "９八">}, {:piece=><Bushido::Piece:70190169751780 玉 king>, :point=>#<Bushido::Point:70190169817240 "７八">}, {:piece=><Bushido::Piece:70190169743180 香 lance>, :point=>#<Bushido::Point:70190173403540 "６八">}, {:piece=><Bushido::Piece:70190169743180 香 lance>, :point=>#<Bushido::Point:70190173400960 "１八">}, {:piece=><Bushido::Piece:70190169743180 香 lance>, :point=>#<Bushido::Point:70190173397880 "９九">}, {:piece=><Bushido::Piece:70190169743300 桂 knight>, :point=>#<Bushido::Point:70190173388220 "８九">}, {:piece=><Bushido::Piece:70190169742980 飛 rook>, :point=>#<Bushido::Point:70190173386420 "３九">}], #<Bushido::Location:0x007facd8470e00 @attributes={:key=>:white, :name=>"後手", :mark=>"▽", :reverse_mark=>"△", :other_marks=>["w"], :varrow=>"v", :angle=>180, :csa_sign=>"-", :code=>1}>=>[{:piece=><Bushido::Piece:70190169743300 桂 knight>, :point=>#<Bushido::Point:70190173431340 "８一">}, {:piece=><Bushido::Piece:70190169743300 桂 knight>, :point=>#<Bushido::Point:70190169935500 "２一">}, {:piece=><Bushido::Piece:70190169743180 香 lance>, :point=>#<Bushido::Point:70190169933420 "１一">}, {:piece=><Bushido::Piece:70190169742980 飛 rook>, :point=>#<Bushido::Point:70190169922520 "９二">}, {:piece=><Bushido::Piece:70190169742900 歩 pawn>, :point=>#<Bushido::Point:70190169903980 "５三">}, {:piece=><Bushido::Piece:70190169751780 玉 king>, :point=>#<Bushido::Point:70190169901120 "３三">}, {:piece=><Bushido::Piece:70190169743300 桂 knight>, :point=>#<Bushido::Point:70190169890080 "３四">}, {:piece=><Bushido::Piece:70190169751680 金 gold>, :point=>#<Bushido::Point:70190169888340 "１四">}, {:piece=><Bushido::Piece:70190169742900 歩 pawn>, :point=>#<Bushido::Point:70190169885320 "８五">}, {:piece=><Bushido::Piece:70190169742900 歩 pawn>, :point=>#<Bushido::Point:70190169872780 "３五">}, {:piece=><Bushido::Piece:70190169742900 歩 pawn>, :point=>#<Bushido::Point:70190169869520 "２五">}, {:piece=><Bushido::Piece:70190169742900 歩 pawn>, :point=>#<Bushido::Point:70190169857680 "１五">}, {:piece=><Bushido::Piece:70190169742900 歩 pawn>, :point=>#<Bushido::Point:70190169853040 "９六">}, {:piece=><Bushido::Piece:70190169743080 角 bishop>, :point=>#<Bushido::Point:70190173419260 "６六">}, {:piece=><Bushido::Piece:70190169742900 歩 pawn>, :point=>#<Bushido::Point:70190169839000 "６七">}, {:piece=><Bushido::Piece:70190169742900 歩 pawn>, :promoted=>true, :point=>#<Bushido::Point:70190169836300 "５七">}]}
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
