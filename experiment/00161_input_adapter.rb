require "./example_helper"

mediator = Mediator.new
mediator.pieces_set("▲銀")
mediator.board.set_from_shape <<~EOT
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・ ・ 飛|
| ・ ・ ・ ・ 馬 ・ 銀 ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ 飛|
+---------------------------+
EOT

player = mediator.player_at(:black)

rows = [
  # "▲１二銀成",
  # "５一角(52)",
  # "▲５五角成",
  # "▲１二銀",
  # "▲１二飛引",

  "▲３一銀",
  "▲３一銀打",
  # "▲１二飛(11)",   "▲１二飛引",   "1112HI", "1a1b",
  # "▲１二飛成(11)", "▲１二飛引成", "1112RY", "1a1b+",
  # "▲１二銀打",     "▲１二銀",     "0012GI", "S*1b",
].collect { |e|
  player_executor = PlayerExecutor.new(player, e)
  input = player_executor.input
  {klass: input.class.name.demodulize, source: e}.merge(input.to_h)
}
tp rows
# >> |------------+------------+------------+-------+-------+----------+-----------------+----------------|
# >> | klass      | source     | point_from | point | piece | promoted | promote_trigger | direct_trigger |
# >> |------------+------------+------------+-------+-------+----------+-----------------+----------------|
# >> | Ki2Adapter | ▲３一銀   | ３二       | ３一  | 銀    | false    | false           | false          |
# >> | Ki2Adapter | ▲３一銀打 |            | ３一  | 銀    | false    | false           | true           |
# >> |------------+------------+------------+-------+-------+----------+-----------------+----------------|
