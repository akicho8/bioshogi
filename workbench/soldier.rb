require "#{__dir__}/setup"

Soldier.from_str("▲76歩")                      # => <Bioshogi::Soldier "▲７六歩">
Soldier.from_str("76歩", location: :white)      # => <Bioshogi::Soldier "△７六歩">


Soldier.from_str("▲12歩").tarefu_desuka?  # => true
Soldier.from_str("▲12歩").normal?         # => true
Soldier.from_str("▲12歩").any_name        # => "歩"
