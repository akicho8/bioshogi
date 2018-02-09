# it "復元できるかテスト" do
#   player = player_test(init: "５五歩")
#   battler = player.battlers.first
#   battler.name.should == "▲５五歩"
#   battler = Marshal.load(Marshal.dump(battler))
#   battler.name.should == "▲５五歩"
# end

# it "１三香は１一香になれないが１一杏にならなれる" do
#   #   １
#   # +---+
#   # | ・|一
#   # | ・|二
#   # | 香|三
#   # +---+
#   Board.size_change([1, 3]) do
#     mediator = Mediator.new
#     mediator.player_at(:black).battlers_create("１三香", from_stand: false)
#     # puts mediator
#     mediator.board["１三"].movable_infos(with_promoted: true).collect(&:to_s).should == ["１二香", "１一杏"]
#     # mediator.board.abone_all
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
#   Board.size_change([1, 3]) do
#     mediator = Mediator.new
#     mediator.player_at(:black).battlers_create("１三杏", from_stand: false)
#     # puts mediator
#     mediator.board["１三"].movable_infos(with_promoted: true).collect(&:to_s).should == ["１二杏"]
#     # mediator.board.abone_all
#   end
# end
