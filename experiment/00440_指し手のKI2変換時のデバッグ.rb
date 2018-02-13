require "./example_helper"

mediator = Mediator.new
mediator.board.set_from_shape(<<~EOT)
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
mediator.next_player.execute("８二銀左引")
official_formatter = mediator.hand_logs.last.official_formatter
tp official_formatter.to_debug_hash
tp official_formatter.options
# >> |----------------+--------------------------------------------------|
# >> |     point_from | ７三                                             |
# >> |       point_to | ８二                                             |
# >> |      candidate | ["△８一銀", "△７一銀", "△９三銀", "△７三銀"] |
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
# >> |    with_mark | false |
# >> | direct_force | false |
# >> |  same_suffix |       |
# >> |      compact | true  |
# >> |--------------+-------|
