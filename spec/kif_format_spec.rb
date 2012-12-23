# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe KifFormat do
    context "kif読み込み" do
      before do
        # file = Pathname(__FILE__).dirname.join("../resources/中飛車実戦61(対穴熊).kif").expand_path
        # file = Pathname(__FILE__).dirname.join("../resources/gekisasi-gps.kif").expand_path
        file = Pathname(__FILE__).dirname.join("sample1.kif").expand_path
        @result = KifFormat::Parser.parse(file.read)
      end

      it "ヘッダー部" do
        @result.header.should == {"開始日時"=>"2000/01/01 00:00:00", "終了日時"=>"2000/01/01 01:00:00", "棋戦"=>"(棋戦)", "持ち時間"=>"(持ち時間)", "手合割"=>"平手", "先手"=>"(先手)", "後手"=>"(後手)"}
      end

      it "棋譜の羅列" do
        @result.move_infos.first.should == {:index => "1", :input => "７六歩(77)", :spent_time => "0:10/00:00:10", :comments => ["コメント1"]}
        @result.move_infos.last.should  == {:index => "5", :input => "投了", :spent_time => "0:10/00:00:50"}
      end

      it "対戦前コメント" do
        @result.start_comments.should == ["指し手に結び付かない対戦前コメント"]
      end
    end

    it "盤面表示" do
      board = Board.new
      players = []
      players << Player.create2(:black, board)
      players << Player.create2(:white, board)
      players.each(&:piece_plot)
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
