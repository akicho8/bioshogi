require "./example_helper"

# Board.logger = ActiveSupport::Logger.new(STDOUT)
# Board.promotable_disable
Board.dimensiton_change([2, 4]) do
  mediator = Mediator.new
  mediator.placement_from_bod <<~EOT
後手の持駒：
+------+
| ・v玉|
| ・ ・|
| 桂 玉|
+------+
先手の持駒：
手数＝0
  EOT
  records = mediator.current_player.brain(diver_class: NegaScoutDiver).interactive_deepning(depth_max_range: 3..3)
  tp Brain.human_format(records)
end
# >> |------+----------------+----------------------------------------+--------+------------+----------|
# >> | 順位 | 候補手         | 読み筋                                 | ▲形勢 | 評価局面数 | 処理時間 |
# >> |------+----------------+----------------------------------------+--------+------------+----------|
# >> |    1 | ▲１一桂成(23) |                                        | 999999 |          0 |  9.3e-05 |
# >> |    2 | ▲２四玉(13)   | △１二玉(11) ▲１四玉(24) △２二玉(12) |    700 |         11 | 0.008541 |
# >> |    3 | ▲１四玉(13)   | △１二玉(11) ▲２四玉(14) △２二玉(12) |    700 |         11 | 0.009635 |
# >> |------+----------------+----------------------------------------+--------+------------+----------|
