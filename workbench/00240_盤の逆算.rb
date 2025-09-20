require "#{__dir__}/setup"

board = Board.new
board.placement_from_preset("トンボ")
board.preset_info                    # => <トンボ>
board.preset_info(major_only: true)  # => nil
board.preset_info(major_only: false) # => <トンボ>

board = Board.new
board.placement_from_preset("二枚落ち")
board.preset_info                    # => <二枚落ち>
board.preset_info(major_only: true)  # => <二枚落ち>
board.preset_info(major_only: false) # => <二枚落ち>
