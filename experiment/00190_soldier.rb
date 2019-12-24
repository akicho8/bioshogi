require "./example_helper"

Soldier.preset_one_side_soldiers("裸玉", location: :black).collect(&:name) # => ["▲５九玉"]
Soldier.preset_one_side_soldiers("裸玉", location: :white).collect(&:name) # => ["△５一玉"]
Soldier.preset_soldiers(white: "裸玉", black: "裸玉").collect(&:name)      # => ["▲５九玉", "△５一玉"]

Soldier.from_str("６八銀").name rescue $! # => #<Bioshogi::MustNotHappen: location missing>

soldier = Soldier.from_str("△６八銀")
soldier.name             # => "△６八銀"
soldier.to_sfen          # => "s"
soldier.bottom_spaces    # => 7
soldier.normalized_place # => #<Bioshogi::Place ４二>

Marshal.load(Marshal.dump(soldier)) == soldier # => true
