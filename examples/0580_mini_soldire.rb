require "./example_helper"

MiniSoldier[point: Point["４二"], piece: Piece["竜"], promoted: true] # => {:point=>#<Bushido::Point:70355809128340 "４二">, :piece=><Bushido::Piece:70355808079360 飛 rook>, :promoted=>true}
a = MiniSoldier[point: Point["１一"], piece: Piece["歩"], promoted: true]
b = MiniSoldier[point: Point["１一"], piece: Piece["歩"], promoted: true]
a == b                     # => true
