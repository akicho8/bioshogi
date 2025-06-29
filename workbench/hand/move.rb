require "#{__dir__}/setup"
move_hand = Bioshogi::Hand::Move.create(soldier: Bioshogi::Soldier.from_str("△62玉"), origin_soldier: Bioshogi::Soldier.from_str("△51玉"))
move_hand.right_move_length  # => 1
move_hand.left_move_length   # => -1
move_hand.up_move_length     # => 1
move_hand.down_move_length   # => -1
