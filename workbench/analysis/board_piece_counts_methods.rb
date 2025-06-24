require "#{__dir__}/setup"

board = Board.create_by_preset("平手")
board.soldiers_count[:white][:bishop] # => 1
board.safe_delete_on(Place["22"])
board.soldiers_count[:white][:bishop] # => 0

board = Board.create_by_preset("平手")
board.soldiers_count_per_location            # => {white: 20, black: 20}
board.safe_delete_on(Place["22"])
board.soldiers_count_per_location            # => {white: 19, black: 20}
