# 盤面の読み取り
require "./example_helper"

board = <<-EOT
+------+
|v桂v香|
| ・ ・|
+------+
EOT
BaseFormat.board_parse(board) # => {#<Bushido::Location:0x007fbb24a78aa0 @attributes={:key=>:black, :mark=>"▲", :other_marks=>["b", "▼", "^"], :name=>"先手", :varrow=>" ", :index=>0}>=>[], #<Bushido::Location:0x007fbb24a788c0 @attributes={:key=>:white, :mark=>"▽", :other_marks=>["w", "△"], :name=>"後手", :varrow=>"v", :index=>1}>=>[{:piece=><Bushido::Piece::Knight:70220866435920 桂 knight>, :point=>#<Bushido::Point:70220866523140 "2一">}, {:piece=><Bushido::Piece::Lance:70220866411300 香 lance>, :point=>#<Bushido::Point:70220866594880 "1一">}]}

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
+---------------------------+ # !> method redefined; discarding old promoted=
EOT
BaseFormat.board_parse(board) # => {#<Bushido::Location:0x007fbb24a78aa0 @attributes={:key=>:black, :mark=>"▲", :other_marks=>["b", "▼", "^"], :name=>"先手", :varrow=>" ", :index=>0}>=>[{:piece=><Bushido::Piece::Bishop:70220866406500 角 bishop>, :promoted=>true, :point=>#<Bushido::Point:70220874613600 "5一">}, {:piece=><Bushido::Piece::Pawn:70220866370120 歩 pawn>, :promoted=>true, :point=>#<Bushido::Point:70220875211960 "4二">}, {:piece=><Bushido::Piece::Silver:70220866431140 銀 silver>, :promoted=>true, :point=>#<Bushido::Point:70220875340120 "6三">}, {:piece=><Bushido::Piece::Silver:70220866431140 銀 silver>, :point=>#<Bushido::Point:70220876016300 "4五">}, {:piece=><Bushido::Piece::Pawn:70220866370120 歩 pawn>, :point=>#<Bushido::Point:70220875923880 "7六">}, {:piece=><Bushido::Piece::Pawn:70220866370120 歩 pawn>, :point=>#<Bushido::Point:70220875745640 "8七">}, {:piece=><Bushido::Piece::Silver:70220866431140 銀 silver>, :point=>#<Bushido::Point:70220875671120 "7七">}, {:piece=><Bushido::Piece::Pawn:70220866370120 歩 pawn>, :point=>#<Bushido::Point:70220875232920 "9八">}, {:piece=><Bushido::Piece::King:70220866468940 玉 king>, :point=>#<Bushido::Point:70220875110260 "7八">}, {:piece=><Bushido::Piece::Lance:70220866411300 香 lance>, :point=>#<Bushido::Point:70220875024680 "6八">}, {:piece=><Bushido::Piece::Lance:70220866411300 香 lance>, :point=>#<Bushido::Point:70220874912420 "1八">}, {:piece=><Bushido::Piece::Lance:70220866411300 香 lance>, :point=>#<Bushido::Point:70220874789920 "9九">}, {:piece=><Bushido::Piece::Knight:70220866435920 桂 knight>, :point=>#<Bushido::Point:70220874684240 "8九">}, {:piece=><Bushido::Piece::Rook:70220866401540 飛 rook>, :point=>#<Bushido::Point:70220874574880 "3九">}], #<Bushido::Location:0x007fbb24a788c0 @attributes={:key=>:white, :mark=>"▽", :other_marks=>["w", "△"], :name=>"後手", :varrow=>"v", :index=>1}>=>[{:piece=><Bushido::Piece::Knight:70220866435920 桂 knight>, :point=>#<Bushido::Point:70220869893800 "8一">}, {:piece=><Bushido::Piece::Knight:70220866435920 桂 knight>, :point=>#<Bushido::Point:70220874798800 "2一">}, {:piece=><Bushido::Piece::Lance:70220866411300 香 lance>, :point=>#<Bushido::Point:70220874985060 "1一">}, {:piece=><Bushido::Piece::Rook:70220866401540 飛 rook>, :point=>#<Bushido::Point:70220875088680 "9二">}, {:piece=><Bushido::Piece::Pawn:70220866370120 歩 pawn>, :point=>#<Bushido::Point:70220875579320 "5三">}, {:piece=><Bushido::Piece::King:70220866468940 玉 king>, :point=>#<Bushido::Point:70220875665800 "3三">}, {:piece=><Bushido::Piece::Knight:70220866435920 桂 knight>, :point=>#<Bushido::Point:70220875817720 "3四">}, {:piece=><Bushido::Piece::Gold:70220866446700 金 gold>, :point=>#<Bushido::Point:70220875865600 "1四">}, {:piece=><Bushido::Piece::Pawn:70220866370120 歩 pawn>, :point=>#<Bushido::Point:70220875975240 "8五">}, {:piece=><Bushido::Piece::Pawn:70220866370120 歩 pawn>, :point=>#<Bushido::Point:70220876187780 "3五">}, {:piece=><Bushido::Piece::Pawn:70220866370120 歩 pawn>, :point=>#<Bushido::Point:70220876243200 "2五">}, {:piece=><Bushido::Piece::Pawn:70220866370120 歩 pawn>, :point=>#<Bushido::Point:70220876036160 "1五">}, {:piece=><Bushido::Piece::Pawn:70220866370120 歩 pawn>, :point=>#<Bushido::Point:70220875990720 "9六">}, {:piece=><Bushido::Piece::Bishop:70220866406500 角 bishop>, :point=>#<Bushido::Point:70220875844780 "6六">}, {:piece=><Bushido::Piece::Pawn:70220866370120 歩 pawn>, :point=>#<Bushido::Point:70220875569600 "6七">}, {:piece=><Bushido::Piece::Pawn:70220866370120 歩 pawn>, :promoted=>true, :point=>#<Bushido::Point:70220875410660 "5七">}]}
