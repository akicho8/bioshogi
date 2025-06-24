require "../setup"

board = Board.create_by_preset("平手")
board.place_on(Soldier.from_str("▲24玉"))
board.place_on(Soldier.from_str("▲25玉"))
board.place_on(Soldier.from_str("▲26玉"))
board.place_on(Soldier.from_str("▲27玉"))
puts board
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/column_soldier_counter.rb:30:in 'Bioshogi::ColumnSoldierCounter#update': 2の列に10個目の駒を配置しようとしています。棋譜を二重に読ませようとしていませんか？ (Bioshogi::MustNotHappen)
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/column_soldier_counter.rb:19:in 'Bioshogi::ColumnSoldierCounter#set'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/analysis/column_soldier_counter_methods.rb:11:in 'Bioshogi::Analysis::ColumnSoldierCounterMethods#place_on'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/analysis/board_piece_counts_methods.rb:11:in 'Bioshogi::Analysis::BoardPieceCountsMethods#place_on'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/analysis/core_soldier_place_methods.rb:9:in 'Bioshogi::Analysis::CoreSoldierPlaceMethods#place_on'
# ~> 	from -:7:in '<main>'
