require "./setup"

board = Board.new
board.placement_from_preset("5五将棋")
board.preset_info               # => <5五将棋>
puts board
