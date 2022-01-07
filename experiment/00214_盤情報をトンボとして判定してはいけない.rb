require "./setup"

board = Board.new
board.placement_from_preset("トンボ")
board.preset_info                     # => nil
board.preset_info(public_name: true)  # => nil
board.preset_info(public_name: false) # => <トンボ>

board = Board.new
board.placement_from_preset("二枚落ち")
board.preset_info                     # => <二枚落ち>
board.preset_info(public_name: true)  # => <二枚落ち>
board.preset_info(public_name: false) # => <二枚落ち>
