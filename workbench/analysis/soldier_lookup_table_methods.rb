require "#{__dir__}/setup"

board = Board.create_by_preset("平手")
board.soldiers_lookup1(:black, :rook)   # => [<Bioshogi::Soldier "▲２八飛">]
board.soldiers_lookup1(:black, :king)   # => [<Bioshogi::Soldier "▲５九玉">]
board.soldiers_lookup1(:black, :bishop) # => [<Bioshogi::Soldier "▲８八角">]
board.soldiers_lookup1(:black, :pawn).many? # => true
board.soldiers_lookup1(:white, :rook)   # => [<Bioshogi::Soldier "△８二飛">]
board.soldiers_lookup1(:white, :king)   # => [<Bioshogi::Soldier "△５一玉">]
board.soldiers_lookup1(:white, :bishop) # => [<Bioshogi::Soldier "△２二角">]
board.soldiers_lookup1(:white, :pawn).many? # => true

board.safe_delete_on(Place["59"])
board.soldiers_lookup1(:black, :king)   # => []

board = Board.create_by_human("△22馬▲88角")
board.soldiers_lookup2(:white, :bishop, true)  # => [<Bioshogi::Soldier "△２二馬">]
board.soldiers_lookup2(:black, :bishop, false) # => [<Bioshogi::Soldier "▲８八角">]
board.soldiers_lookup2(:black, :rook, false)   # => []
