# -*- coding: utf-8 -*-
# 盤面の読み取り

require "./example_helper"

board = <<-EOT
+------+
|v桂v香|
| ・ ・|
+------+
EOT
BaseFormat.board_parse(board) # => {#<Bushido::Location:0x007f86c2a64e38 @attributes={key: :black, mark: "▲", other_marks: ["b", "▼", "^"], name: "先手", varrow: " ", index: 0}>=>[], #<Bushido::Location:0x007f86c2a64a28 @attributes={key: :white, mark: "▽", other_marks: ["w", "△"], name: "後手", varrow: "v", index: 1}>=>[{piece: <Bushido::Piece::Knight:70108381891140 桂 knight>, promoted: false, point: #<Bushido::Point:70108381925140 "2一">}, {piece: <Bushido::Piece::Lance:70108381884460 香 lance>, promoted: false, point: #<Bushido::Point:70108381944780 "1一">}]}

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
BaseFormat.board_parse(board) # => {#<Bushido::Location:0x007f86c2a64e38 @attributes={key: :black, mark: "▲", other_marks: ["b", "▼", "^"], name: "先手", varrow: " ", index: 0}>=>[{piece: <Bushido::Piece::Bishop:70108381861260 角 bishop>, promoted: true, point: #<Bushido::Point:70108382017240 "5一">}, {piece: <Bushido::Piece::Pawn:70108381868080 歩 pawn>, promoted: true, point: #<Bushido::Point:70108382126080 "4二">}, {piece: <Bushido::Piece::Silver:70108381887560 銀 silver>, promoted: true, point: #<Bushido::Point:70108382147680 "6三">}, {piece: <Bushido::Piece::Silver:70108381887560 銀 silver>, promoted: false, point: #<Bushido::Point:70108382326060 "4五">}, {piece: <Bushido::Piece::Pawn:70108381868080 歩 pawn>, promoted: false, point: #<Bushido::Point:70108382345800 "7六">}, {piece: <Bushido::Piece::Pawn:70108381868080 歩 pawn>, promoted: false, point: #<Bushido::Point:70108382302280 "8七">}, {piece: <Bushido::Piece::Silver:70108381887560 銀 silver>, promoted: false, point: #<Bushido::Point:70108382281800 "7七">}, {piece: <Bushido::Piece::Pawn:70108381868080 歩 pawn>, promoted: false, point: #<Bushido::Point:70108382193560 "9八">}, {piece: <Bushido::Piece::King:70108381897460 玉 king>, promoted: false, point: #<Bushido::Point:70108382174680 "7八">}, {piece: <Bushido::Piece::Lance:70108381884460 香 lance>, promoted: false, point: #<Bushido::Point:70108382148960 "6八">}, {piece: <Bushido::Piece::Lance:70108381884460 香 lance>, promoted: false, point: #<Bushido::Point:70108382124060 "1八">}, {piece: <Bushido::Piece::Lance:70108381884460 香 lance>, promoted: false, point: #<Bushido::Point:70108382102340 "9九">}, {piece: <Bushido::Piece::Knight:70108381891140 桂 knight>, promoted: false, point: #<Bushido::Point:70108382075280 "8九">}, {piece: <Bushido::Piece::Rook:70108381873020 飛 rook>, promoted: false, point: #<Bushido::Point:70108382049900 "3九">}], #<Bushido::Location:0x007f86c2a64a28 @attributes={key: :white, mark: "▽", other_marks: ["w", "△"], name: "後手", varrow: "v", index: 1}>=>[{piece: <Bushido::Piece::Knight:70108381891140 桂 knight>, promoted: false, point: #<Bushido::Point:70108381992640 "8一">}, {piece: <Bushido::Piece::Knight:70108381891140 桂 knight>, promoted: false, point: #<Bushido::Point:70108382051240 "2一">}, {piece: <Bushido::Piece::Lance:70108381884460 香 lance>, promoted: false, point: #<Bushido::Point:70108382075160 "1一">}, {piece: <Bushido::Piece::Rook:70108381873020 飛 rook>, promoted: false, point: #<Bushido::Point:70108382098140 "9二">}, {piece: <Bushido::Piece::Pawn:70108381868080 歩 pawn>, promoted: false, point: #<Bushido::Point:70108382194800 "5三">}, {piece: <Bushido::Piece::King:70108381897460 玉 king>, promoted: false, point: #<Bushido::Point:70108382206020 "3三">}, {piece: <Bushido::Piece::Knight:70108381891140 桂 knight>, promoted: false, point: #<Bushido::Point:70108382241720 "3四">}, {piece: <Bushido::Piece::Gold:70108381900980 金 gold>, promoted: false, point: #<Bushido::Point:70108382277540 "1四">}, {piece: <Bushido::Piece::Pawn:70108381868080 歩 pawn>, promoted: false, point: #<Bushido::Point:70108382297340 "8五">}, {piece: <Bushido::Piece::Pawn:70108381868080 歩 pawn>, promoted: false, point: #<Bushido::Point:70108382335700 "3五">}, {piece: <Bushido::Piece::Pawn:70108381868080 歩 pawn>, promoted: false, point: #<Bushido::Point:70108382365660 "2五">}, {piece: <Bushido::Piece::Pawn:70108381868080 歩 pawn>, promoted: false, point: #<Bushido::Point:70108382378840 "1五">}, {piece: <Bushido::Piece::Pawn:70108381868080 歩 pawn>, promoted: false, point: #<Bushido::Point:70108382363700 "9六">}, {piece: <Bushido::Piece::Bishop:70108381861260 角 bishop>, promoted: false, point: #<Bushido::Point:70108382324640 "6六">}, {piece: <Bushido::Piece::Pawn:70108381868080 歩 pawn>, promoted: false, point: #<Bushido::Point:70108382252140 "6七">}, {piece: <Bushido::Piece::Pawn:70108381868080 歩 pawn>, promoted: true, point: #<Bushido::Point:70108382229180 "5七">}]}
