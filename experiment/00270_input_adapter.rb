require "./example_helper"

mediator = Mediator.new
mediator.pieces_set("▲銀")
mediator.board.placement_from_shape <<~EOT
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・ ・ 飛|
| ・ ・ ・ ・ 馬 ・ 銀 ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ 飛|
+---------------------------+
EOT

player = mediator.player_at(:black)

rows = [
  "△１二銀成",
  "▲１二銀成",
  "５一角(52)",
  "▲５五角成",
  "▲１二銀",
  "▲１二飛引",
  "▲３一銀",
  "▲３一銀打",
  "▲１二飛(11)",   "▲１二飛引",   "1112HI", "1a1b",
  "▲１二飛成(11)", "▲１二飛引成", "1112RY", "1a1b+",
  "▲１二銀打",     "▲１二銀",     "0012GI", "S*1b",
].collect { |e|
  player_executor = PlayerExecutorHuman.new(player, e)
  input = player_executor.input
  input.perform_validations
  {klass: input.class.name.demodulize, source: e}.merge(input.to_h)
}
tp rows
# >> |------------+----------------+------------+-------+-------+----------+-----------------+----------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> | klass      | source         | place_from | place | piece | promoted | promote_trigger | drop_trigger | errors                                                                                                                                                                                                 |
# >> |------------+----------------+------------+-------+-------+----------+-----------------+----------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> | Ki2Adapter | △１二銀成     |            | １二  | 銀    | true     | true            | false          | [{:error_class=>Warabi::DifferentTurnCommonError, :message=>"先手の手番で後手が着手しました"}, {:error_class=>Warabi::MovableBattlerNotFound, :message=>"先手の手番で１二に移動できる駒がありません"}] |
# >> | Ki2Adapter | ▲１二銀成     |            | １二  | 銀    | true     | true            | false          | [{:error_class=>Warabi::MovableBattlerNotFound, :message=>"先手の手番で１二に移動できる駒がありません"}]                                                                                               |
# >> | KifAdapter | ５一角(52)     | ５二       | ５一  | 角    | false    | false           | false          | [{:error_class=>Warabi::PromotedPieceToNormalPiece, :message=>"成った状態から成らない状態に戻れません"}]                                                                                               |
# >> | Ki2Adapter | ▲５五角成     |            | ５五  | 角    | true     | true            | false          | [{:error_class=>Warabi::MovableBattlerNotFound, :message=>"先手の手番で５五に移動できる駒がありません"}]                                                                                               |
# >> | Ki2Adapter | ▲１二銀       |            | １二  | 銀    | false    | false           | true           | []                                                                                                                                                                                                     |
# >> | Ki2Adapter | ▲１二飛引     | １一       | １二  | 飛    | false    | false           | false          | []                                                                                                                                                                                                     |
# >> | Ki2Adapter | ▲３一銀       | ３二       | ３一  | 銀    | false    | false           | false          | []                                                                                                                                                                                                     |
# >> | Ki2Adapter | ▲３一銀打     |            | ３一  | 銀    | false    | false           | true           | []                                                                                                                                                                                                     |
# >> | KifAdapter | ▲１二飛(11)   | １一       | １二  | 飛    | false    | false           | false          | []                                                                                                                                                                                                     |
# >> | Ki2Adapter | ▲１二飛引     | １一       | １二  | 飛    | false    | false           | false          | []                                                                                                                                                                                                     |
# >> | CsaAdapter | 1112HI         | １一       | １二  | 飛    | false    | false           | false          | []                                                                                                                                                                                                     |
# >> | UsiAdapter | 1a1b           | １一       | １二  | 飛    | false    | false           | false          | []                                                                                                                                                                                                     |
# >> | KifAdapter | ▲１二飛成(11) | １一       | １二  | 飛    | true     | true            | false          | []                                                                                                                                                                                                     |
# >> | Ki2Adapter | ▲１二飛引成   | １一       | １二  | 飛    | true     | true            | false          | []                                                                                                                                                                                                     |
# >> | CsaAdapter | 1112RY         | １一       | １二  | 飛    | true     | true            | false          | []                                                                                                                                                                                                     |
# >> | UsiAdapter | 1a1b+          | １一       | １二  | 飛    | true     | true            | false          | []                                                                                                                                                                                                     |
# >> | Ki2Adapter | ▲１二銀打     |            | １二  | 銀    | false    | false           | true           | []                                                                                                                                                                                                     |
# >> | Ki2Adapter | ▲１二銀       |            | １二  | 銀    | false    | false           | true           | []                                                                                                                                                                                                     |
# >> | CsaAdapter | 0012GI         |            | １二  | 銀    | false    | false           | true           | []                                                                                                                                                                                                     |
# >> | UsiAdapter | S*1b           |            | １二  | 銀    | false    | false           | true           | []                                                                                                                                                                                                     |
# >> |------------+----------------+------------+-------+-------+----------+-----------------+----------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
