require "./example_helper"

MiniSoldier.new(point: Point["４二"], piece: Piece["竜"], promoted: true) # => {:point=>#<Bushido::Point:70355864308500 "４二">, :piece=><Bushido::Piece:70355861598180 飛 rook>, :promoted=>true}

a = MiniSoldier.new(point: Point["１一"], piece: Piece["歩"], promoted: true)
b = MiniSoldier.new(point: Point["１一"], piece: Piece["歩"], promoted: true)
a == b                     # => true
