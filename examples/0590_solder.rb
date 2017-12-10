require "./example_helper"

Soldier[point: Point["４二"], piece: Piece["竜"], promoted: true] # => {:point=>#<Bushido::Point:70272305417620 "４二">, :piece=><Bushido::Piece:70272305929400 飛 rook>, :promoted=>true}
a = Soldier[point: Point["１一"], piece: Piece["歩"], promoted: true]
b = Soldier[point: Point["１一"], piece: Piece["歩"], promoted: true]
a == b                     # => true
