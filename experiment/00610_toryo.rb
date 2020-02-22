require "./example_helper"

# Board.logger = ActiveSupport::Logger.new(STDOUT)
# Board.promotable_disable
Board.dimensiton_change([3, 4])

mediator = Mediator.new
# mediator.placement_from_bod <<~EOT
# 後手の持駒：
# +---------+
# | ・v歩v玉|
# |v飛 ・ ・|
# | ・ ・ 玉|
# +---------+
# 先手の持駒：桂
# EOT

mediator.placement_from_bod <<~EOT
後手の持駒：
+---------+
| ・v香v玉|
| ・v歩 ・|
| ・ ・ ・|
| ・ 桂 玉|
+---------+
先手の持駒：桂金
手数＝1
EOT

# puts mediator

# mediator.execute("▲24桂打")
# captured_soldier = mediator.opponent_player.executor.captured_soldier
# captured_soldier                # => nil

# 王手された状態で後手の手番

# player = mediator.current_player
# soldier = player.soldiers.first                                   # => <Bioshogi::Soldier "▲２四桂">
# soldier.move_list(mediator.board).to_a # => [<▲１二桂成(24)>]
# exit
#
# mediator.current_player.soldiers # =>
#
# mediator.current_player.brain(diver_class: Diver::NegaScoutDiver).move_hands(promoted_only: true).to_a # =>
# exit

mediator.current_player.brain(diver_class: Diver::NegaScoutDiver).create_all_hands(promoted_only: true).to_a # => [<△１二玉(11)>, <△２三歩成(22)>]
records = mediator.current_player.brain(diver_class: Diver::NegaScoutDiver).iterative_deepening(time_limit: nil, depth_max_range: 5..5)
record = records.first
tp record
hand = record[:hand]
if record[:score] <= -(Bioshogi::SCORE_MAX - 1)
  p "投了"
end
tp Brain.human_format(records)

# # 後手は王手してきた金を取った状態
# mediator.execute(hand.to_sfen, executor_class: PlayerExecutorCpu)
# puts mediator
#
# # 先手の手番でその玉を取る
# records = mediator.current_player.brain(diver_class: Diver::NegaScoutDiver).iterative_deepening(time_limit: 3, depth_max_range: 0..8)
# record = records.first
# tp record
# tp Brain.human_format(records)
# mediator.execute(record[:hand].to_sfen, executor_class: PlayerExecutorCpu)

#   if captured_soldier && captured_soldier.piece.key == :king
#     break
#   end
# end
# >> |------------+----------------|
# >> |       hand | △２三歩成(22) |
# >> |      score | 999999         |
# >> |     score2 | -999999        |
# >> |    best_pv | [MATE]     |
# >> | eval_times | 0              |
# >> |        sec | 0.003939       |
# >> |------------+----------------|
# >> |------+----------------+--------+---------+------------+----------|
# >> | 順位 | 候補手         | 読み筋 | ▲形勢  | 評価局面数 | 処理時間 |
# >> |------+----------------+--------+---------+------------+----------|
# >> |    1 | △２三歩成(22) | (詰み) | -999999 |          0 | 0.003939 |
# >> |------+----------------+--------+---------+------------+----------|
