# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Frame do
    it do
      frame = Frame.setup
      frame.players[0].initial_put_on("５六歩")
      frame.players[1].initial_put_on("５五飛")
      frame.piece_discard
      frame.players[0].execute("５五歩")
      frame.players[0].piece_names.should == ["飛"]
      # p frame
    end

    it "棋譜の配列をパースして▲▽を考慮して交互に打つ" do
      pending
    end
    it "戦況表示" do
      pending
    end
    it "N手目を一発で表示" do
      pending
    end
  end
end
