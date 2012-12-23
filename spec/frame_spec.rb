# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Frame do
    it do
      frame = Frame.sit_down
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

  describe LiveFrame do
    it do
      # @result = KifFormat::Parser.parse(Pathname(__FILE__).dirname.join("sample1.kif"))
      @result = Bushido.parse(Pathname(__FILE__).dirname.join("../resources/中飛車実戦61(対穴熊).kif"))
      # @result = Bushido.parse(Pathname(__FILE__).dirname.join("../resources/竜王戦_ki2/九段戦1950-01 大山板谷-2.ki2"))
      frame = LiveFrame.sit_down
      frame.piece_plot
      @result.move_infos.each{|move_info|
        frame.execute(move_info[:input])
        frame.inspect
      }
      frame.a_move_logs.join(" ")
    end
  end
end
