# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe do
    it "読み込み" do
      # file = Pathname(__FILE__).dirname.join("../resources/中飛車実戦61(対穴熊).kif").expand_path
      file = Pathname(__FILE__).dirname.join("../resources/gekisasi-gps.kif").expand_path
      text = file.read
      obj = KifFormat::Parser.parse(text)
      obj.header.should == {"開始日時" => "2010/01/15 09:28:52", "終了日時" => "2010/01/15 12:18:26", "棋戦" => "第五回 世界最強決定戦 2010", "持ち時間" => "各1時間", "手合割" => "平手", "先手" => "激指", "後手" => "GPS将棋"}
    end

    it "盤面表示" do
      board = Board.new
      players = []
      players << Player.create2(:black, board)
      players << Player.create2(:white, board)
      players.each(&:setup)
      board.to_kif_table.should == <<-FIELD.strip_heredoc
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金v銀v桂v香|一
| ・v飛 ・ ・ ・ ・ ・v角 ・|二
|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 銀 桂 香|九
+---------------------------+
FIELD
    end
  end
end
