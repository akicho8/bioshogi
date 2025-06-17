require "#{__dir__}/setup"
container = Container::Basic.new
# container.placement_from_preset("平手")
container.board.placement_from_human("▲53玉 ▲23飛 △51玉 △22角")
container.player_at(:black).soldiers.collect(&:name) # => ["▲５三玉", "▲２三飛"]
container.player_at(:black).king_soldier.name        # => "▲５三玉"
container.player_at(:black).to_s_soldiers            # => "２三飛 ５三玉"
container.player_at(:black).king_soldier_entered?    # => true
container.player_at(:black).soldiers_ek_score        # => 5
container.player_at(:black).many_soliders_are_in_the_opponent_area?        # => false
container.player_at(:black).entered_soldiers.collect(&:name)        # => ["▲２三飛"]

puts container
# >> 後手の持駒：なし
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・ ・ ・v玉 ・ ・ ・ ・|一
# >> | ・ ・ ・ ・ ・ ・ ・v角 ・|二
# >> | ・ ・ ・ ・ 玉 ・ ・ 飛 ・|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# >> +---------------------------+
# >> 先手の持駒：なし
# >> 手数＝0 まで
# >> 先手番
