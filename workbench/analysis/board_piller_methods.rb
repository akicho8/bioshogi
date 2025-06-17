require "#{__dir__}/setup"

board = Board.create_by_preset("平手")
board.piller_counts               # => {0=>4, 1=>6, 2=>4, 3=>4, 4=>4, 5=>4, 6=>4, 7=>6, 8=>4}
board.safe_delete_on(Place["22"]) # => <Bioshogi::Soldier "△２二角">
board.piller_counts               # => {0=>4, 1=>6, 2=>4, 3=>4, 4=>4, 5=>4, 6=>4, 7=>5, 8=>4}
