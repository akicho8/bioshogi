require "../setup"

# Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

Dimension::Row.promotable_disabled
Dimension.change([1, 6])

container = Container::Basic.new
container.placement_from_bod <<~EOT
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

brain = container.player_at(:white).brain(diver_class: AI::Diver::NegaAlphaMateDiver)
records = brain.iterative_deepening(depth_max_range: 0..7)
tp AI::Brain.human_format(records)
# 遅すぎて使えない

# >> |------+------------+---------------------+--------+------------+----------|
# >> | 順位 | 候補手     | 読み筋              | ▲形勢 | 評価局面数 | 処理時間 |
# >> |------+------------+---------------------+--------+------------+----------|
# >> |    1 | △１二歩打 | ▲１四飛(15) (詰み) |      1 |          0 | 0.001759 |
# >> |    2 | △１三歩打 | ▲１四飛(15) (詰み) |      1 |          0 | 0.001644 |
# >> |    3 | △１四歩打 | ▲１四飛(15) (詰み) |      1 |          0 |  0.00107 |
# >> |------+------------+---------------------+--------+------------+----------|
