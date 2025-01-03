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

brain = container.player_at(:white).brain(diver_class: AI::Diver::NegaAlphaDiver)
records = brain.iterative_deepening(depth_max_range: 0..7)
tp AI::Brain.human_format(records)
# 遅すぎて使えない

# >> |------+------------+----------------------------------------------------------------------------------------+--------+------------+----------|
# >> | 順位 | 候補手     | 読み筋                                                                                 | ▲形勢 | 評価局面数 | 処理時間 |
# >> |------+------------+----------------------------------------------------------------------------------------+--------+------------+----------|
# >> |    1 | △１三歩打 | ▲１三飛(15) △１二歩打 ▲１二飛(13) △１二玉(11) ▲１二飛(16) △１一飛打 ▲１一飛(12) |  44310 |        992 | 0.109207 |
# >> |    2 | △１四歩打 | ▲１四飛(15) △１二歩打 ▲１二飛(14) △１二玉(11) ▲１二飛(16) △１一飛打 ▲１一飛(12) |  44310 |        490 | 0.045481 |
# >> |    3 | △１二歩打 | ▲１二飛(15) △１二玉(11) ▲１二飛(16) △１一飛打 ▲１一飛(12) △１二歩打 ▲１二飛(11) |  44310 |        917 | 0.087018 |
# >> |------+------------+----------------------------------------------------------------------------------------+--------+------------+----------|
