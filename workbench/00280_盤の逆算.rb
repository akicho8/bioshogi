require "#{__dir__}/setup"

board = Board.new
board.placement_from_preset("トンボ")
board.preset_info                         # => nil
board.preset_info(inclusion_minor: false) # => nil
board.preset_info(inclusion_minor: true)  # => <トンボ>

board = Board.new
board.placement_from_preset("二枚落ち")
board.preset_info                         # => <二枚落ち>
board.preset_info(inclusion_minor: false) # => <二枚落ち>
board.preset_info(inclusion_minor: true)  # => <二枚落ち>
