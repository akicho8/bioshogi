require "#{__dir__}/setup"
e = Bioshogi::Analysis::UsedSoldierCounter.new
hand = Bioshogi::Hand::Drop.create(soldier: Soldier.from_str("▲12飛"))
e.update(hand)
hand = Bioshogi::Hand::Move.create(soldier: Soldier.from_str("▲12竜"), origin_soldier: Soldier.from_str("▲11竜"))
e.update(hand)
