require "#{__dir__}/setup"

board = Board.create_by_preset("平手")
board.soldiers_lookup(:black, :rook)   # => [<Bioshogi::Soldier "▲２八飛">]
board.soldiers_lookup(:black, :king)   # => [<Bioshogi::Soldier "▲５九玉">]
board.soldiers_lookup(:black, :bishop) # => [<Bioshogi::Soldier "▲８八角">]
board.soldiers_lookup(:black, :pawn).many? # => true
board.soldiers_lookup(:white, :rook)   # => [<Bioshogi::Soldier "△８二飛">]
board.soldiers_lookup(:white, :king)   # => [<Bioshogi::Soldier "△５一玉">]
board.soldiers_lookup(:white, :bishop) # => [<Bioshogi::Soldier "△２二角">]
board.soldiers_lookup(:white, :pawn).many? # => true

board.safe_delete_on(Place["59"])
board.soldiers_lookup(:black, :king)   # => []
