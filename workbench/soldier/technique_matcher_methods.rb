require "./setup"
Soldier.from_str("▲11歩").to_bottom_place # => #<Bioshogi::Place １九>
Soldier.from_str("▲15歩").to_bottom_place # => #<Bioshogi::Place １九>
Soldier.from_str("▲19歩").to_bottom_place # => #<Bioshogi::Place １九>

Soldier.from_str("▲19香").maeni_ittyokusen?  # => true
Soldier.from_str("▲19飛").maeni_ittyokusen?  # => true
Soldier.from_str("▲19杏").maeni_ittyokusen?  # => false
Soldier.from_str("▲19角").maeni_ittyokusen?  # => false
