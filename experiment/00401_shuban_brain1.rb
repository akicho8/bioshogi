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
  [
    NegaAlphaDiver,
    NegaScoutDiver,
  ].each do |diver_class|
    brain = mediator.current_player.brain(diver_class: diver_class) # NegaAlphaDiver
    records = brain.iterative_deepening(depth_max_range: 4..4)
    tp Brain.human_format(records)
  end
end
# >> |------+----------------+--------+--------+------------+----------|
# >> | 順位 | 候補手         | 読み筋 | ▲形勢 | 評価局面数 | 処理時間 |
# >> |------+----------------+--------+--------+------------+----------|
# >> |    1 | ▲１一桂成(23) |        | 999999 |          0 |        0 |
# >> |------+----------------+--------+--------+------------+----------|
# >> |------+----------------+--------+--------+------------+----------|
# >> | 順位 | 候補手         | 読み筋 | ▲形勢 | 評価局面数 | 処理時間 |
# >> |------+----------------+--------+--------+------------+----------|
# >> |    1 | ▲１一桂成(23) |        | 999999 |          0 |        0 |
# >> |------+----------------+--------+--------+------------+----------|
