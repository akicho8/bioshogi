require "../setup"

# Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

# Dimension::PlaceY.promotable_disabled
Dimension.wh_change([4, 9])

container = Container::Basic.new
container.player_at(:black).pieces_add("金桂")
container.board.placement_from_shape <<~EOT
+------------+
| 馬 ・v桂v香|
| ・ ・ ・v玉|
| ・ ・ 歩v銀|
| ・ ・ ・v歩|
+------------+
EOT

# tp container.player_at(:black).normal_all_hands(legal_only: true, mate_only: true)

mate_records = []
mate_proc = proc do |player, score, hand_route|
  mate_records << {"評価値" => score, "詰み筋" => hand_route.collect(&:to_s).join(" "), "詰み側" => player.location.to_s, "攻め側の持駒" => player.op.piece_box.to_s}
end

# brain = container.player_at(:black).brain(diver_class: Ai::Diver::NegaScoutDiver)
# records = brain.iterative_deepening(depth_max_range: 5..5, mate_mode: true, mate_proc: mate_proc)
# tp Ai::Brain.human_format(records)

player = container.player_at(:black)
object = Ai::Diver::NegaAlphaDiver.new(depth_max: 6, current_player: player, mate_mode: true, base_player: player, mate_proc: mate_proc)
tp object.dive
tp mate_records

# >> |--------------------------------------------------------------------------------------------|
# >> |                                                                                     999994 |
# >> | [<▲２四桂打>, <△２四銀(13)>, <▲２二歩成(23)>, <△１三玉(12)>, <▲２三馬(41)>, "(詰み)"] |
# >> |--------------------------------------------------------------------------------------------|
# >> |--------+------------------------------------------------------------------+--------+--------------|
# >> | 評価値 | 詰み筋                                                           | 詰み側 | 攻め側の持駒 |
# >> |--------+------------------------------------------------------------------+--------+--------------|
# >> | 999994 | ▲２二歩成(23) △２二玉(12) ▲３二馬(41) △１二玉(22) ▲２三金打 | △     | 桂           |
# >> | 999994 | ▲２二歩成(23) △２二玉(12) ▲２三馬(41) △３一玉(22) ▲４一金打 | △     | 桂           |
# >> | 999994 | ▲２二歩成(23) △２二玉(12) ▲２三馬(41) △３一玉(22) ▲３二金打 | △     | 桂           |
# >> | 999994 | ▲２二歩成(23) △２二玉(12) ▲３三金打 △１二玉(22) ▲２三馬(41) | △     | 桂           |
# >> | 999994 | ▲２二歩成(23) △２二玉(12) ▲３三金打 △１二玉(22) ▲２三金(33) | △     | 桂           |
# >> | 999996 | ▲２二歩成(23) △２二玉(12) ▲２三金打                           | △     | 桂           |
# >> | 999994 | ▲２二歩成(23) △２二玉(12) ▲３四桂打 △１二玉(22) ▲２三金打   | △     |              |
# >> | 999994 | ▲２二金打 △２二銀(13) ▲２二歩成(23) △１三玉(12) ▲２三馬(41) | △     | 銀 桂        |
# >> | 999994 | ▲２二金打 △２二銀(13) ▲２二歩成(23) △１三玉(12) ▲２三と(22) | △     | 銀 桂        |
# >> | 999994 | ▲２四桂打 △２四銀(13) ▲２二歩成(23) △１三玉(12) ▲２三馬(41) | △     | 金           |
# >> | 999994 | ▲２四桂打 △２四銀(13) ▲２二歩成(23) △１三玉(12) ▲２三と(22) | △     | 金           |
# >> | 999994 | ▲２四桂打 △２四銀(13) ▲２二歩成(23) △１三玉(12) ▲２三金打   | △     |              |
# >> | 999994 | ▲２四桂打 △２四銀(13) ▲２二歩成(23) △２二玉(12) ▲２三金打   | △     |              |
# >> |--------+------------------------------------------------------------------+--------+--------------|
