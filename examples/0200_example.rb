# 初期配置文字列のパース
require "./example_helper"

info = MiniSoldier.from_str("７六と")
info[:piece].name # => "歩"
info[:promoted]   # => true
info[:point].name # => "7六"

tp info
# >> |----------+------|
# >> |    piece | 歩   |
# >> | promoted | true |
# >> |    point | 7六  |
# >> |----------+------|
