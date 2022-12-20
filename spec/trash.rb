# it "復元できるかテスト" do
#   player = Container::Basic.player_test(init: "５五歩")
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
#   Dimension.wh_change([1, 3]) do
#     container = Container::Basic.new
#     container.player_at(:black).soldier_create("１三香")
#     # puts container
#     assert { container.board["１三"].move_list(with_promoted: true).collect(&:to_s) == ["１二香", "１一杏"] }
#     # container.board.all_clear
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
#   Dimension.wh_change([1, 3]) do
#     container = Container::Basic.new
#     container.player_at(:black).soldier_create("１三杏")
#     # puts container
#     assert { container.board["１三"].move_list(with_promoted: true).collect(&:to_s) == ["１二杏"] }
#     # container.board.all_clear
#   end
# end
