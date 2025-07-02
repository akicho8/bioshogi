require "#{__dir__}/setup"

info = Parser.parse(<<~EOT)
手数----指手---------消費時間--
1 ７六歩(77)   ( 0:02/00:00:02)
2 ３四歩(33)   ( 0:02/00:00:02)
3 反則勝ち
EOT
tp info.pi.move_infos
tp info.pi.last_action_info1         # => <TORYO>
tp info.pi.output_last_action_info  # => <TORYO>
info.container.judgment_message     # => "まで2手で後手の勝ち"
info.to_csa.lines.last.strip        # => "%TORYO"
# >> |-------------+------------+---------------+--------------|
# >> | turn_number | input      | clock_part    | used_seconds |
# >> |-------------+------------+---------------+--------------|
# >> |           1 | ７六歩(77) | 0:02/00:00:02 |            2 |
# >> |           2 | ３四歩(33) | 0:02/00:00:02 |            2 |
# >> |-------------+------------+---------------+--------------|
# >> |----------------------+-------|
# >> |                  key | TORYO |
# >> |        kakinoki_word | 投了  |
# >> |               reason |       |
# >> |                 draw |       |
# >> | win_player_collect_p | true  |
# >> |                 code | 0     |
# >> |----------------------+-------|
# >> |----------------------+-------|
# >> |                  key | TORYO |
# >> |        kakinoki_word | 投了  |
# >> |               reason |       |
# >> |                 draw |       |
# >> | win_player_collect_p | true  |
# >> |                 code | 0     |
# >> |----------------------+-------|
