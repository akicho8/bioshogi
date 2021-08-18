require "../example_helper"

# Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

Board.promotable_disable
Board.dimensiton_change([1, 6])

mediator = Mediator.new
mediator.placement_from_bod <<~EOT
後手の持駒：歩2
+---+
|v玉|
| ・|
| ・|
| ・|
| 飛|
| 飛|
+---+
先手の持駒：
EOT

brain = mediator.player_at(:white).brain(diver_class: Diver::NegaAlphaMateDiver)
records = brain.iterative_deepening(depth_max_range: 0..7)
tp Brain.human_format(records)
# 遅すぎて使えない

# >> |------+------------+---------------------+--------+------------+----------|
# >> | 順位 | 候補手     | 読み筋              | ▲形勢 | 評価局面数 | 処理時間 |
# >> |------+------------+---------------------+--------+------------+----------|
# >> |    1 | △１二歩打 | ▲１四飛(15) (詰み) |      1 |          0 | 0.001759 |
# >> |    2 | △１三歩打 | ▲１四飛(15) (詰み) |      1 |          0 | 0.001644 |
# >> |    3 | △１四歩打 | ▲１四飛(15) (詰み) |      1 |          0 |  0.00107 |
# >> |------+------------+---------------------+--------+------------+----------|
