require "spec_helper"

module Bushido
  describe Board do
    it "サンプル" do
      board = Board.new
      board["５五"].should == nil
    end

    it "指定の座標だけを消す微妙なテスト" do
      Board.size_change([1, 3]) do
        mediator = Mediator.new
        mediator.player_b.initial_soldiers("１三香", from_piece: false)
        mediator.board.__abone_cell(Point["１三"])
        mediator.board["１三"].should == nil
      end
    end
  end
end
