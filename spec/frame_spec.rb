# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Frame do
    it do
      frame = Frame.players_join
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
      # @result = Bushido.parse(Pathname(__FILE__).dirname.join("../resources/中飛車実戦61(対穴熊).kif"))
      # @result = Bushido.parse(Pathname(__FILE__).dirname.join("../resources/竜王戦_ki2/九段戦1950-01 大山板谷-2.ki2"))

      # # どっちの銀か、わからない
      @result = Bushido.parse(Pathname(__FILE__).dirname.join("../resources/竜王戦_ki2/十段戦1968-07 大山加藤-7.ki2"))

      # @result = Bushido.parse(Pathname(__FILE__).dirname.join("../resources/竜王戦_ki2/龍王戦2012-25 渡辺丸山-5.ki2"))

      frame = LiveFrame.players_join
      frame.piece_plot
      @result.move_infos.each{|move_info|
        # p move_info[:input]
        frame.execute(move_info[:input])
        frame.inspect
        # p frame
      }
      frame.a_move_logs.join(" ")
    end
  end
end
