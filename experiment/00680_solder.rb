require "./example_helper"

Soldier[point: Point["４二"], piece: Piece["竜"], promoted: true] # => {:point=>#<Warabi::Point:70187980914640 "４二">, :piece=><Warabi::Piece:70187995514380 飛 rook>, :promoted=>true}
a = Soldier[point: Point["１一"], piece: Piece["歩"], promoted: true]
b = Soldier[point: Point["１一"], piece: Piece["歩"], promoted: true]
a == b                     # => true
