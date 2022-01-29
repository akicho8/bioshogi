require "../setup"

board = Board.create_by_preset("平手")
board.place_on(Soldier.from_str("▲24玉"))
board.place_on(Soldier.from_str("▲25玉"))
board.place_on(Soldier.from_str("▲26玉"))
board.place_on(Soldier.from_str("▲27玉"))
puts board
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/board_piller_methods.rb:13:in `place_on': 2の列に10個目の駒を配置しようとしています。棋譜を二重に読ませようとしていませんか？ (Bioshogi::MustNotHappen)
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/board_piece_counts_methods.rb:9:in `place_on'
# ~> 	from -:7:in `<main>'
