require "./example_helper"

Soldier.preset_one_side_soldiers("裸玉", location: :black).collect(&:name) # => ["▲５九玉"]
Soldier.preset_one_side_soldiers("裸玉", location: :white).collect(&:name) # => ["△５一玉"]
Soldier.preset_soldiers(white: "裸玉", black: "裸玉").collect(&:name)      # => ["▲５九玉", "△５一玉"]

Soldier.movs_split("▲４二銀 △４二銀")      # => ["▲４二銀", "△４二銀"]
Soldier.ki2_parse("▲５五歩△４四歩 push ▲３三歩 pop")  # => ["▲５五歩", "△４四歩", "▲３三歩"]
InputParser.slice_one("▲５五歩△６八銀")                        # => "▲５五歩"
Soldier.movs_split("▲５五歩△４四歩 push ▲３三歩 pop") # => ["▲５五歩", "△４四歩", "▲３三歩"]
Soldier.movs_split("５五歩")                             # => ["５五歩"]

Soldier.from_str("６八銀").name rescue $! # => #<Warabi::WarabiError: location missing>

soldier = Soldier.from_str("△６八銀")
soldier.name         # => "△６八銀"
soldier.to_sfen      # => "s"

Marshal.load(Marshal.dump(soldier)) == soldier # => true
