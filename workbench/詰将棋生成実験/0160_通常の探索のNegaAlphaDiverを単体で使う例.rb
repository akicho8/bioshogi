require "../setup"

# 失敗
# 勝手読みの詰みを収集するだけになっている

# Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

Dimension.change([2, 5])

container = Container::Basic.new
container.player_at(:black).pieces_add("金3")
container.board.placement_from_shape <<~EOT
+------+
| ・ ・|
| ・ ・|
| ・v玉|
| ・ ・|
| ・ 歩|
+------+
EOT

mate_records = []
mate_proc = proc do |player, score, hand_route|
  mate_records << { "評価値" => score, "詰み筋" => hand_route.collect(&:to_s).join(" "), "詰み側" => player.location.to_s, "攻め側の持駒" => player.op.piece_box.to_s }
end

player = container.player_at(:black)
object = AI::Diver::NegaAlphaDiver.new(evaluator_class: Evaluator::Level1, depth_max: 6, current_player: player, mate_mode: true, base_player: player, mate_proc: mate_proc)
tp object.dive
tp mate_records

# >> |--------------------------------------------------------------------------------------|
# >> |                                                                               999994 |
# >> | [<▲２四金打>, <△２四玉(13)>, <▲１四金打>, <△２五玉(24)>, <▲２四金打>, "(詰み)"] |
# >> |--------------------------------------------------------------------------------------|
# >> |--------+------------------------------------------------------------------+--------+--------------|
# >> | 評価値 | 詰み筋                                                           | 詰み側 | 攻め側の持駒 |
# >> |--------+------------------------------------------------------------------+--------+--------------|
# >> | 999994 | ▲１四歩(15) △１四玉(13) ▲２四金打 △１五玉(14) ▲１四金打     | △     | 金           |
# >> | 999994 | ▲１四歩(15) △１四玉(13) ▲２四金打 △１五玉(14) ▲２五金打     | △     | 金           |
# >> | 999994 | ▲１四歩(15) △２四玉(13) ▲２五金打 △２三玉(24) ▲１三金打     | △     | 金           |
# >> | 999994 | ▲１四歩(15) △２四玉(13) ▲１五金打 △２三玉(24) ▲１三金打     | △     | 金           |
# >> | 999994 | ▲１四歩(15) △１二玉(13) ▲１三歩成(14) △１一玉(12) ▲２二金打 | △     | 金二         |
# >> | 999994 | ▲１四歩(15) △１二玉(13) ▲１三歩成(14) △１一玉(12) ▲１二金打 | △     | 金二         |
# >> | 999994 | ▲１四歩(15) △１二玉(13) ▲１三歩成(14) △２一玉(12) ▲２二金打 | △     | 金二         |
# >> | 999994 | ▲１四歩(15) △１二玉(13) ▲１三歩成(14) △２一玉(12) ▲１二金打 | △     | 金二         |
# >> | 999994 | ▲１四歩(15) △１二玉(13) ▲１三歩(14) △１一玉(12) ▲１二金打   | △     | 金二         |
# >> | 999994 | ▲１四歩(15) △１二玉(13) ▲１三歩(14) △２一玉(12) ▲１二金打   | △     | 金二         |
# >> | 999994 | ▲１四歩(15) △１二玉(13) ▲２三金打 △１一玉(12) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲１四歩(15) △１二玉(13) ▲２三金打 △１一玉(12) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲１四歩(15) △１二玉(13) ▲２三金打 △２一玉(12) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲１四歩(15) △１二玉(13) ▲２三金打 △２一玉(12) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲１四歩(15) △１二玉(13) ▲１三金打 △１一玉(12) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲１四歩(15) △１二玉(13) ▲１三金打 △１一玉(12) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲１四歩(15) △１二玉(13) ▲１三金打 △２一玉(12) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲１四歩(15) △１二玉(13) ▲１三金打 △２一玉(12) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲１四歩(15) △２二玉(13) ▲１三歩成(14) △１一玉(22) ▲２二金打 | △     | 金二         |
# >> | 999994 | ▲１四歩(15) △２二玉(13) ▲１三歩成(14) △１一玉(22) ▲１二金打 | △     | 金二         |
# >> | 999994 | ▲１四歩(15) △２二玉(13) ▲１三歩成(14) △２一玉(22) ▲２二金打 | △     | 金二         |
# >> | 999994 | ▲１四歩(15) △２二玉(13) ▲１三歩成(14) △２一玉(22) ▲１二金打 | △     | 金二         |
# >> | 999994 | ▲１四歩(15) △２二玉(13) ▲２一金打 △１二玉(22) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲１四歩(15) △２二玉(13) ▲２三金打 △１一玉(22) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲１四歩(15) △２二玉(13) ▲２三金打 △１一玉(22) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲１四歩(15) △２二玉(13) ▲２三金打 △２一玉(22) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲１四歩(15) △２二玉(13) ▲２三金打 △２一玉(22) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲１四歩(15) △２二玉(13) ▲１三金打 △１一玉(22) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲１四歩(15) △２二玉(13) ▲１三金打 △１一玉(22) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲１四歩(15) △２二玉(13) ▲１三金打 △２一玉(22) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲１四歩(15) △２二玉(13) ▲１三金打 △２一玉(22) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲１二金打 △２四玉(13) ▲１四金打 △２五玉(24) ▲２四金打       | △     |              |
# >> | 999994 | ▲１二金打 △２四玉(13) ▲２五金打 △２三玉(24) ▲２二金打       | △     |              |
# >> | 999994 | ▲１二金打 △２四玉(13) ▲２五金打 △２三玉(24) ▲１三金打       | △     |              |
# >> | 999994 | ▲１二金打 △２三玉(13) ▲２二金(12) △１三玉(23) ▲２三金打     | △     | 金           |
# >> | 999994 | ▲１二金打 △１二玉(13) ▲２二金打 △１三玉(12) ▲２三金打       | △     |              |
# >> | 999994 | ▲１二金打 △１二玉(13) ▲２三金打 △１一玉(12) ▲２二金打       | △     |              |
# >> | 999994 | ▲１二金打 △１二玉(13) ▲２三金打 △１一玉(12) ▲１二金打       | △     |              |
# >> | 999994 | ▲１二金打 △１二玉(13) ▲２三金打 △２一玉(12) ▲２二金打       | △     |              |
# >> | 999994 | ▲１二金打 △１二玉(13) ▲２三金打 △２一玉(12) ▲１二金打       | △     |              |
# >> | 999994 | ▲１二金打 △１二玉(13) ▲１三金打 △１一玉(12) ▲２二金打       | △     |              |
# >> | 999994 | ▲１二金打 △１二玉(13) ▲１三金打 △１一玉(12) ▲１二金打       | △     |              |
# >> | 999994 | ▲１二金打 △１二玉(13) ▲１三金打 △２一玉(12) ▲２二金打       | △     |              |
# >> | 999994 | ▲１二金打 △１二玉(13) ▲１三金打 △２一玉(12) ▲１二金打       | △     |              |
# >> | 999994 | ▲２三金打 △２三玉(13) ▲２二金打 △１三玉(23) ▲２三金打       | △     |              |
# >> | 999994 | ▲２四金打 △２四玉(13) ▲１四金打 △２五玉(24) ▲２四金打       | △     |              |
# >> | 999994 | ▲２四金打 △１二玉(13) ▲２三金(24) △１一玉(12) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲２四金打 △１二玉(13) ▲２三金(24) △１一玉(12) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲２四金打 △１二玉(13) ▲２三金(24) △２一玉(12) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲２四金打 △１二玉(13) ▲２三金(24) △２一玉(12) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲２四金打 △１二玉(13) ▲１三金(24) △１一玉(12) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲２四金打 △１二玉(13) ▲１三金(24) △１一玉(12) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲２四金打 △１二玉(13) ▲１三金(24) △２一玉(12) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲２四金打 △１二玉(13) ▲１三金(24) △２一玉(12) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲２四金打 △１二玉(13) ▲１一金打 △２二玉(12) ▲２一金打       | △     |              |
# >> | 999994 | ▲２四金打 △１二玉(13) ▲１一金打 △２二玉(12) ▲１二金打       | △     |              |
# >> | 999994 | ▲２四金打 △１二玉(13) ▲２三金打 △１一玉(12) ▲２二金打       | △     |              |
# >> | 999994 | ▲２四金打 △１二玉(13) ▲２三金打 △１一玉(12) ▲１二金打       | △     |              |
# >> | 999994 | ▲２四金打 △１二玉(13) ▲２三金打 △２一玉(12) ▲２二金打       | △     |              |
# >> | 999994 | ▲２四金打 △１二玉(13) ▲２三金打 △２一玉(12) ▲１二金打       | △     |              |
# >> | 999994 | ▲２四金打 △１二玉(13) ▲１三金打 △１一玉(12) ▲２二金打       | △     |              |
# >> | 999994 | ▲２四金打 △１二玉(13) ▲１三金打 △１一玉(12) ▲１二金打       | △     |              |
# >> | 999994 | ▲２四金打 △１二玉(13) ▲１三金打 △２一玉(12) ▲２二金打       | △     |              |
# >> | 999994 | ▲２四金打 △１二玉(13) ▲１三金打 △２一玉(12) ▲１二金打       | △     |              |
# >> | 999994 | ▲２四金打 △２二玉(13) ▲２三金(24) △１一玉(22) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲２四金打 △２二玉(13) ▲２三金(24) △１一玉(22) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲２四金打 △２二玉(13) ▲２三金(24) △２一玉(22) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲２四金打 △２二玉(13) ▲２三金(24) △２一玉(22) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲２四金打 △２二玉(13) ▲１三金(24) △１一玉(22) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲２四金打 △２二玉(13) ▲１三金(24) △１一玉(22) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲２四金打 △２二玉(13) ▲１三金(24) △２一玉(22) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲２四金打 △２二玉(13) ▲１三金(24) △２一玉(22) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲２四金打 △２二玉(13) ▲２一金打 △１二玉(22) ▲１一金打       | △     |              |
# >> | 999994 | ▲２四金打 △２二玉(13) ▲２一金打 △１二玉(22) ▲２二金打       | △     |              |
# >> | 999994 | ▲２四金打 △２二玉(13) ▲２三金打 △１一玉(22) ▲２二金打       | △     |              |
# >> | 999994 | ▲２四金打 △２二玉(13) ▲２三金打 △１一玉(22) ▲１二金打       | △     |              |
# >> | 999994 | ▲２四金打 △２二玉(13) ▲２三金打 △２一玉(22) ▲２二金打       | △     |              |
# >> | 999994 | ▲２四金打 △２二玉(13) ▲２三金打 △２一玉(22) ▲１二金打       | △     |              |
# >> | 999994 | ▲２四金打 △２二玉(13) ▲１三金打 △１一玉(22) ▲２二金打       | △     |              |
# >> | 999994 | ▲２四金打 △２二玉(13) ▲１三金打 △１一玉(22) ▲１二金打       | △     |              |
# >> | 999994 | ▲２四金打 △２二玉(13) ▲１三金打 △２一玉(22) ▲２二金打       | △     |              |
# >> | 999994 | ▲２四金打 △２二玉(13) ▲１三金打 △２一玉(22) ▲１二金打       | △     |              |
# >> | 999994 | ▲１四金打 △１二玉(13) ▲２三金(14) △１一玉(12) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲１四金打 △１二玉(13) ▲２三金(14) △１一玉(12) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲１四金打 △１二玉(13) ▲２三金(14) △２一玉(12) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲１四金打 △１二玉(13) ▲２三金(14) △２一玉(12) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲１四金打 △１二玉(13) ▲１三金(14) △１一玉(12) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲１四金打 △１二玉(13) ▲１三金(14) △１一玉(12) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲１四金打 △１二玉(13) ▲１三金(14) △２一玉(12) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲１四金打 △１二玉(13) ▲１三金(14) △２一玉(12) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲１四金打 △１二玉(13) ▲１一金打 △２二玉(12) ▲２一金打       | △     |              |
# >> | 999994 | ▲１四金打 △１二玉(13) ▲１一金打 △２二玉(12) ▲１二金打       | △     |              |
# >> | 999994 | ▲１四金打 △１二玉(13) ▲２三金打 △１一玉(12) ▲２二金打       | △     |              |
# >> | 999994 | ▲１四金打 △１二玉(13) ▲２三金打 △１一玉(12) ▲１二金打       | △     |              |
# >> | 999994 | ▲１四金打 △１二玉(13) ▲２三金打 △２一玉(12) ▲２二金打       | △     |              |
# >> | 999994 | ▲１四金打 △１二玉(13) ▲２三金打 △２一玉(12) ▲１二金打       | △     |              |
# >> | 999994 | ▲１四金打 △１二玉(13) ▲１三金打 △１一玉(12) ▲２二金打       | △     |              |
# >> | 999994 | ▲１四金打 △１二玉(13) ▲１三金打 △１一玉(12) ▲１二金打       | △     |              |
# >> | 999994 | ▲１四金打 △１二玉(13) ▲１三金打 △２一玉(12) ▲２二金打       | △     |              |
# >> | 999994 | ▲１四金打 △１二玉(13) ▲１三金打 △２一玉(12) ▲１二金打       | △     |              |
# >> | 999994 | ▲１四金打 △２二玉(13) ▲２三金(14) △１一玉(22) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲１四金打 △２二玉(13) ▲２三金(14) △１一玉(22) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲１四金打 △２二玉(13) ▲２三金(14) △２一玉(22) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲１四金打 △２二玉(13) ▲２三金(14) △２一玉(22) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲１四金打 △２二玉(13) ▲１三金(14) △１一玉(22) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲１四金打 △２二玉(13) ▲１三金(14) △１一玉(22) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲１四金打 △２二玉(13) ▲１三金(14) △２一玉(22) ▲２二金打     | △     | 金           |
# >> | 999994 | ▲１四金打 △２二玉(13) ▲１三金(14) △２一玉(22) ▲１二金打     | △     | 金           |
# >> | 999994 | ▲１四金打 △２二玉(13) ▲２一金打 △１二玉(22) ▲１一金打       | △     |              |
# >> | 999994 | ▲１四金打 △２二玉(13) ▲２一金打 △１二玉(22) ▲２二金打       | △     |              |
# >> | 999994 | ▲１四金打 △２二玉(13) ▲２三金打 △１一玉(22) ▲２二金打       | △     |              |
# >> | 999994 | ▲１四金打 △２二玉(13) ▲２三金打 △１一玉(22) ▲１二金打       | △     |              |
# >> | 999994 | ▲１四金打 △２二玉(13) ▲２三金打 △２一玉(22) ▲２二金打       | △     |              |
# >> | 999994 | ▲１四金打 △２二玉(13) ▲２三金打 △２一玉(22) ▲１二金打       | △     |              |
# >> | 999994 | ▲１四金打 △２二玉(13) ▲１三金打 △１一玉(22) ▲２二金打       | △     |              |
# >> | 999994 | ▲１四金打 △２二玉(13) ▲１三金打 △１一玉(22) ▲１二金打       | △     |              |
# >> | 999994 | ▲１四金打 △２二玉(13) ▲１三金打 △２一玉(22) ▲２二金打       | △     |              |
# >> | 999994 | ▲１四金打 △２二玉(13) ▲１三金打 △２一玉(22) ▲１二金打       | △     |              |
# >> |--------+------------------------------------------------------------------+--------+--------------|
