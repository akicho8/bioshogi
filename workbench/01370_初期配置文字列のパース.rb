require "./setup"

tp Soldier.from_str("▲７六と")

tp Soldier.from_str("７六と")
Soldier.from_str("７六と").name # => "？７六と"
# >> |----------+------|
# >> |    piece | 歩   |
# >> | promoted | true |
# >> |    place | ７六 |
# >> | location | ▲   |
# >> |----------+------|
# >> |----------+------|
# >> |    piece | 歩   |
# >> | promoted | true |
# >> |    place | ７六 |
# >> | location |      |
# >> |----------+------|
