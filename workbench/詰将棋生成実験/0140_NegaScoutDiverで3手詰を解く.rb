require "../setup"

# Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

Dimension.change([2, 4])

container = Container::Basic.new
container.player_at(:black).pieces_add("金金")
container.board.placement_from_shape <<~EOT
+------+
| ・ ・|
| ・v玉|
| ・ ・|
| ・ 歩|
+------+
EOT

# tp container.player_at(:black).normal_all_hands(legal_only: true, mate_only: true)

brain = container.player_at(:black).brain(diver_class: AI::Diver::NegaScoutDiver)
records = brain.iterative_deepening(depth_max_range: 3..3, mate_mode: true)
tp AI::Brain.human_format(records)

# >> |------+----------------+--------------------------------------+--------+------------+----------|
# >> | 順位 | 候補手         | 読み筋                               | ▲形勢 | 評価局面数 | 処理時間 |
# >> |------+----------------+--------------------------------------+--------+------------+----------|
# >> |    1 | ▲１三金打     | △１一玉(12) ▲２二金打 (詰み)       | 999997 |          6 | 0.003899 |
# >> |    2 | ▲２二金打     | △２二玉(12) ▲１三金打 △１一玉(22) | -39960 |         12 | 0.004743 |
# >> |    3 | ▲２三金打     | △２三玉(12) ▲１三金打 △２四玉(23) | -39960 |          9 | 0.006092 |
# >> |    4 | ▲１三歩成(14) | △１三玉(12) ▲１二金打 △１二玉(13) | -40105 |         11 | 0.005515 |
# >> |    5 | ▲１三歩(14)   | △１三玉(12) ▲１二金打 △１二玉(13) | -40105 |         17 | 0.008613 |
# >> |    6 | ▲１一金打     | △１一玉(12) ▲２一金打 △２一玉(11) | -42420 |         22 | 0.009403 |
# >> |------+----------------+--------------------------------------+--------+------------+----------|
