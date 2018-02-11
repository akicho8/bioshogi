require "./example_helper"

object = HandLog.new(point_to: Point["７六"], piece: Piece["歩"], point_from: Point["７七"])
object.to_kif                   # => 
object.to_ki2                   # => 
object.to_kif_ki2
