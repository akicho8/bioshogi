require "#{__dir__}/setup"

board = Board.create_by_preset("平手")
board.specific_piece_count_for(:white, :bishop) # => 1
board.safe_delete_on(Place["22"])
board.specific_piece_count_for(:white, :bishop) # => 0

board = Board.create_by_preset("平手")
board.location_piece_counts            # => {:white=>20, :black=>20}
board.safe_delete_on(Place["22"])
board.location_piece_counts            # => {:white=>19, :black=>20}
