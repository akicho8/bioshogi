require "#{__dir__}/setup"
move_hand = Bioshogi::Hand::Move.create(soldier: Bioshogi::Soldier.from_str("△62玉"), origin_soldier: Bioshogi::Soldier.from_str("△51玉"))
move_hand.right_move_length  # => 1
move_hand.left_move_length   # => -1
move_hand.up_move_length     # => 1
move_hand.down_move_length   # => -1

Bioshogi::Hand::Move.create(soldier: Bioshogi::Soldier.from_str("▲55玉"), origin_soldier: Bioshogi::Soldier.from_str("▲56玉")).move_vector == Bioshogi::V.up # => true
Bioshogi::Hand::Move.create(soldier: Bioshogi::Soldier.from_str("▲55玉"), origin_soldier: Bioshogi::Soldier.from_str("▲54玉")).move_vector == Bioshogi::V.down # => true
Bioshogi::Hand::Move.create(soldier: Bioshogi::Soldier.from_str("▲55玉"), origin_soldier: Bioshogi::Soldier.from_str("▲45玉")).move_vector == Bioshogi::V.left # => true
Bioshogi::Hand::Move.create(soldier: Bioshogi::Soldier.from_str("▲55玉"), origin_soldier: Bioshogi::Soldier.from_str("▲65玉")).move_vector == Bioshogi::V.right # => true

Bioshogi::Hand::Move.create(soldier: Bioshogi::Soldier.from_str("△55玉"), origin_soldier: Bioshogi::Soldier.from_str("△56玉")).move_vector == Bioshogi::V.down # => true
Bioshogi::Hand::Move.create(soldier: Bioshogi::Soldier.from_str("△55玉"), origin_soldier: Bioshogi::Soldier.from_str("△54玉")).move_vector == Bioshogi::V.up   # => true
Bioshogi::Hand::Move.create(soldier: Bioshogi::Soldier.from_str("△55玉"), origin_soldier: Bioshogi::Soldier.from_str("△45玉")).move_vector == Bioshogi::V.right # => true
Bioshogi::Hand::Move.create(soldier: Bioshogi::Soldier.from_str("△55玉"), origin_soldier: Bioshogi::Soldier.from_str("△65玉")).move_vector == Bioshogi::V.left  # => true
