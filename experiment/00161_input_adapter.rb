require "./example_helper"

mediator = Mediator.new
mediator.pieces_set("▲銀")
mediator.board.set_from_shape <<~EOT
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・ ・ 飛|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ 飛|
+---------------------------+
EOT

player = mediator.player_at(:black)

rows = [
  "▲１二飛(11)",   "▲１二飛引",   "1112HI", "1a1b",
  "▲１二飛成(11)", "▲１二飛引成", "1112RY", "1a1b+",
  "▲１二銀打",     "▲１二銀",     "0012GI", "S*1b",
].collect { |e|
  player_executor = PlayerExecutor.new(player, e)
  input = player_executor.input
  {klass: input.class.name.demodulize, source: e}.merge(input.to_h)
}
tp rows
# >> |------------+----------------+------------+-------+-------+----------+-----------------+----------------|
# >> | klass      | source         | point_from | point | piece | promoted | promote_trigger | direct_trigger |
# >> |------------+----------------+------------+-------+-------+----------+-----------------+----------------|
# >> | KifAdapter | ▲１二飛(11)   | １一       | １二  | 飛    | false    | false           | false          |
# >> | Ki2Adapter | ▲１二飛引     |            | １二  | 飛    | false    | false           | false          |
# >> | CsaAdapter | 1112HI         | １一       | １二  | 飛    | false    | false           | false          |
# >> | UsiAdapter | 1a1b           | １一       | １二  | 飛    | false    | false           | false          |
# >> | KifAdapter | ▲１二飛成(11) | １一       | １二  | 飛    | true     | true            | false          |
# >> | Ki2Adapter | ▲１二飛引成   |            | １二  | 飛    | true     | true            | false          |
# >> | CsaAdapter | 1112RY         | １一       | １二  | 飛    | true     | true            | false          |
# >> | UsiAdapter | 1a1b+          | １一       | １二  | 飛    | true     | true            | false          |
# >> | Ki2Adapter | ▲１二銀打     |            | １二  | 銀    | false    | false           | true           |
# >> | Ki2Adapter | ▲１二銀       |            | １二  | 銀    | false    | false           | false          |
# >> | CsaAdapter | 0012GI         |            | １二  | 銀    | false    | false           | true           |
# >> | UsiAdapter | S*1b           |            | １二  | 銀    | false    | false           | true           |
# >> |------------+----------------+------------+-------+-------+----------+-----------------+----------------|
