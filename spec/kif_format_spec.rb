# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe KifFormat do
    describe "kif読み込み" do
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
        @result.move_infos.first.should == {index: "1", location: L.b, input: "７六歩(77)", mov: "▲７六歩(77)", spent_time: "0:10/00:00:10", comments: ["コメント1"]}
        @result.move_infos.last.should  == {index: "5", location: L.b, input: "投了", mov: "▲投了", spent_time: "0:10/00:00:50"}
      end

      it "対局前コメント" do
        @result.first_comments.should == ["対局前コメント"]
      end
    end

    it "盤面表示" do
      mediator = Mediator.start
      mediator.piece_plot
      mediator.board.to_s.should == <<-EOT.strip_heredoc
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
EOT
    end

    it "詰将棋用のファイル" do
      contents = <<-EOT
# ----  柿木将棋VII V7.10 棋譜ファイル  ----
表題：看寿2003.DIA #56
作者：岡村孝雄
発表誌：詰パラ 2003年11月号 P.19
手合割：平手　　
後手の持駒：飛二　角　銀二　桂四　香四　歩九　
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・ ・ ・|一
| ・ ・ ・ ・ ・v玉 ・ ・ ・|二
| ・ ・ ・ ・ ・ ・ ・ ・ ・|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| ・ ・ ・ ・ ・ ・ ・ ・ ・|七
| ・ ・ ・ ・ ・ ・ ・ ・ ・|八
| ・ ・ ・ ・ ・ ・ ・ ・ ・|九
+---------------------------+
先手の持駒：角　金四　銀二　歩九　
先手：
後手：
手数----指手---------消費時間--
   1 ６四角打     ( 0:00/00:00:00)
   2 ５三角打     ( 0:00/00:00:00)
EOT
      info = KifFormat::Parser.parse(contents)
      # pp info
      info.header[:board].present?.should == true
    end

    # curl -O http://swks.sakura.ne.jp/wars/kifu/akicho8-JackTuti-20130609_201346.kif
    it "将棋ウォーズ棋譜変換サイトが生成したKIFフォーマットが読める" do
      info = KifFormat::Parser.parse(Pathname(__FILE__).dirname.join("../resources/akicho8-JackTuti-20130609_201346.kif").expand_path)
      info.header.should be_present
      info.move_infos.should be_present
    end
  end
end
