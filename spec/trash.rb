# it "復元できるかテスト" do
#   player = Mediator.player_test(init: "５五歩")
#   soldier = player.soldiers.first
#   assert { soldier.name == "▲５五歩" }
#   soldier = Marshal.load(Marshal.dump(soldier))
#   assert { soldier.name == "▲５五歩" }
# end

# it "１三香は１一香になれないが１一杏にならなれる" do
#   #   １
#   # +---+
#   # | ・|一
#   # | ・|二
#   # | 香|三
#   # +---+
#   Board.dimensiton_change([1, 3]) do
#     mediator = Mediator.new
#     mediator.player_at(:black).soldier_create("１三香")
#     # puts mediator
#     assert { mediator.board["１三"].move_list(with_promoted: true).collect(&:to_s) == ["１二香", "１一杏"] }
#     # mediator.board.all_clear
#   end
# end
#
# it "１三杏は１二杏にしか移動できない" do
#   #   １
#   # +---+
#   # | ・|一
#   # | ・|二
#   # | 杏|三
#   # +---+
#   Board.dimensiton_change([1, 3]) do
#     mediator = Mediator.new
#     mediator.player_at(:black).soldier_create("１三杏")
#     # puts mediator
#     assert { mediator.board["１三"].move_list(with_promoted: true).collect(&:to_s) == ["１二杏"] }
#     # mediator.board.all_clear
#   end
# end
