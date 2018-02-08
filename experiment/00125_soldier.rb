require "./example_helper"

Soldier.location_soldiers(location: :black, key: "裸玉").collect(&:name) # => ["▲５九玉"]
Soldier.location_soldiers(location: :white, key: "裸玉").collect(&:name) # => ["△５一玉"]

Soldier.from_str("６八銀").name rescue $! # => "？６八銀"

soldier = Soldier.from_str("△６八銀")
soldier.name         # => "△６八銀"
soldier.to_sfen      # => "s"
