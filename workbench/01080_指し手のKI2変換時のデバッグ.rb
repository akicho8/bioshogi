require "#{__dir__}/setup"

container = Container::Basic.new
container.board.placement_from_shape(<<~EOT)
+---------------------------+
| ・v銀v銀 ・ ・ ・vとvとvと|
| ・ ○ ・ ・ ・ ・ ・ ○vと|
|v銀 ・v銀 ・ ・ ・ ・vと ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・v金v金v金 ・ ・ ・|
| ・ ・ ・ ・ ○ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
+---------------------------+
EOT
container.next_player.execute("８二銀左引")
official_formatter = container.hand_logs.last.official_formatter
tp official_formatter.to_debug_hash
tp official_formatter.options
# >> |----------------+--------------------------------------------------|
# >> |     place_from | ７三                                             |
# >> |       place_to | ８二                                             |
# >> |      candidate_soldiers | ["△８一銀", "△７一銀", "△９三銀", "△７三銀"] |
# >> |       koreru_c | 4                                                |
# >> |     _migi_idou | false                                            |
# >> |   _hidari_idou | true                                             |
# >> |       _ue_idou | true                                             |
# >> |    _shita_idou | false                                            |
# >> | _hidari_kara_c | 1                                                |
# >> |   _migi_kara_c | 2                                                |
# >> |       yoreru_c | 0                                                |
# >> |      agareru_c | 2                                                |
# >> |     sagareru_c | 2                                                |
# >> |        shita_y | 0                                                |
# >> |            _tx | 1                                                |
# >> |            _ty | 1                                                |
# >> |            _ox | 2                                                |
# >> |            _oy | 2                                                |
# >> |            _xr | 0..2                                             |
# >> |            _yr | 0..2                                             |
# >> |----------------+--------------------------------------------------|
# >> |--------------+-------|
# >> |    with_location | false |
# >> | force_drop | false |
# >> |  same_suffix |       |
# >> |      compact | true  |
# >> |--------------+-------|
