# -*- coding: utf-8 -*-

# it "復元できるかテスト" do
#   player = player_test(init: "5五歩")
#   soldier = player.soldiers.first
#   soldier.formality_name.should == "▲5五歩"
#   soldier = Marshal.load(Marshal.dump(soldier))
#   soldier.formality_name.should == "▲5五歩"
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
#     mediator.player_b.initial_soldiers("１三香", from_piece: false)
#     # puts mediator
#     mediator.board["１三"].moveable_points(with_promoted: true).collect(&:to_s).should == ["1二香", "1一杏"]
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
#     mediator.player_b.initial_soldiers("１三杏", from_piece: false)
#     # puts mediator
#     mediator.board["１三"].moveable_points(with_promoted: true).collect(&:to_s).should == ["1二杏"]
#     # mediator.board.abone_all
#   end
# end
