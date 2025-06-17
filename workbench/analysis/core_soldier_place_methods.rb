require "#{__dir__}/setup"

board = Board.create_by_preset("平手")
board.core_soldier_places_for(:black, :rook)   # => #<Bioshogi::Place ２八>
board.core_soldier_places_for(:black, :king)   # => #<Bioshogi::Place ５九>
board.core_soldier_places_for(:black, :bishop) # => #<Bioshogi::Place ８八>
board.core_soldier_places_for(:black, :pawn)   # => nil
board.core_soldier_places_for(:white, :rook)   # => #<Bioshogi::Place ８二>
board.core_soldier_places_for(:white, :king)   # => #<Bioshogi::Place ５一>
board.core_soldier_places_for(:white, :bishop) # => #<Bioshogi::Place ２二>
board.core_soldier_places_for(:white, :pawn)   # => nil

board.safe_delete_on(Place["59"])
board.core_soldier_places_for(:black, :king)   # => nil
