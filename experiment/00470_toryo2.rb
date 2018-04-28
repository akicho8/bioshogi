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
| ・v香 ・|
| ・v歩v玉|
| ・ ・ ・|
| ・ 桂 玉|
+---------+
先手の持駒：
手数＝0
EOT

mediator.execute("▲12桂成")
mediator.opponent_player.executor.captured_soldier # => <Warabi::Soldier "△１二玉">
# captured_soldier                # => nil

# 王手された状態で後手の手番

# player = mediator.current_player
# soldier = player.soldiers.first                                   # => <Warabi::Soldier "▲２四桂">
# soldier.move_list(mediator.board, promoted_preferred: false).to_a # => [<▲１二桂成(24)>]
# exit
#
# mediator.current_player.soldiers # =>
#
# mediator.current_player.brain(diver_class: NegaScoutDiver).move_hands.to_a # =>
# exit

mediator.current_player.brain(diver_class: NegaScoutDiver).normal_all_hands.to_a # => [<△２三歩成(22)>]
records = mediator.current_player.brain(diver_class: NegaScoutDiver).iterative_deepening(time_limit: nil, depth_max_range: 5..5)
record = records.first
tp record
hand = record[:hand]
if record[:score] <= -(Warabi::INF_MAX - 1)
  p "投了"
end
tp Brain.human_format(records)

# # 後手は王手してきた金を取った状態
# mediator.execute(hand.to_sfen, executor_class: PlayerExecutorCpu)
# puts mediator
#
# # 先手の手番でその玉を取る
# records = mediator.current_player.brain(diver_class: NegaScoutDiver).iterative_deepening(time_limit: 3, depth_max_range: 0..8)
# record = records.first
# tp record
# tp Brain.human_format(records)
# mediator.execute(record[:hand].to_sfen, executor_class: PlayerExecutorCpu)

#   if captured_soldier && captured_soldier.piece.key == :king
#     break
#   end
# end
# >> |------------+--------------------------------|
# >> |       hand | △２三歩成(22)                 |
# >> |      score | 999999                         |
# >> |     score2 | -999999                        |
# >> |    best_pv | [<▲３一玉打>, <△１四と(23)>] |
# >> | eval_times | 0                              |
# >> |        sec | 0.025289                       |
# >> |------------+--------------------------------|
# >> |------+----------------+-------------------------+---------+------------+----------|
# >> | 順位 | 候補手         | 読み筋                  | ▲形勢  | 評価局面数 | 処理時間 |
# >> |------+----------------+-------------------------+---------+------------+----------|
# >> |    1 | △２三歩成(22) | ▲３一玉打 △１四と(23) | -999999 |          0 | 0.025289 |
# >> |------+----------------+-------------------------+---------+------------+----------|
