require_relative "../spec_helper"

module Bioshogi
  describe Parser::KifParser do
    it "72手目で投了する場合71手目は先手が指しているので次の手番は後手になっている" do
      info = Parser.parse("72 投了")
      assert { info.mediator.turn_info.turn_offset == 0               } # 内部的には0手目
      assert { info.mediator.turn_info.display_turn == 71             } # 表示するなら現在71手目
      assert { info.mediator.turn_info.current_location.key == :white } # 手番は△
      assert { info.to_kif.include?("1 投了")                         } # KIFにしたとき復元している→しないのが正しい
    end

    it "移動元を明示したのに駒がなかったときの例外に指し手の情報が含まれている" do
      proc { Parser.parse("55歩(56)").to_kif }.should raise_error(PieceNotFoundOnBoard, /棋譜/)
    end

    it "残り時間の変換" do
      info = Parser.parse("持ち時間：1時間01分")
      info.to_kif.include?("持ち時間：1時間01分")
      info.to_csa.include?("01:00+00")
    end

    describe "kif読み込み" do
      before do
        @info = Parser::KifParser.parse(<<~EOT)
# ----  Kifu for Windows V6.22 棋譜ファイル  ----
開始日時：2000/01/01 00:00:00
終了日時：2000/01/01 01:00:00
棋戦：(棋戦)
持ち時間：(持ち時間)
手合割：平手　　
先手：(先  手)
後手：(後手)
*放映日：2003/09/7
*棋戦詳細：第53回ＮＨＫ杯戦2回戦第05局
*「(先 手)七段」vs「(後手)九段」
手数----指手---------消費時間--
*対局前コメント
   1 ７六歩(77)   ( 0:10/00:00:10)
*コメント1
   2 ３四歩(33)   ( 0:10/00:00:20)
   3 ６六歩(67)   ( 0:10/00:00:30)
   4 ８四歩(83)   ( 0:10/00:00:40)
*コメント2
   5 投了         ( 0:10/00:00:50)
まで4手で後手の勝ち
変化：1手
   1 ２六歩(25)   ( 0:10/00:00:10)
EOT
      end

      it "ヘッダー部" do
        assert do
          @info.header.to_h == {
            "開始日時" => "2000/01/01",
            "終了日時" => "2000/01/01 01:00:00",
            "棋戦"     => "(棋戦)",
            "持ち時間" => "(持ち時間)",
            "放映日"   => "2003/09/07",
            "棋戦詳細" => "第53回NHK杯戦2回戦第5局",
            "手合割"   => "平手",
            "先手"     => "(先  手)",
            "先手詳細" => "(先 手)七段",
            "後手"     => "(後手)",
            "後手詳細" => "(後手)九段",
          }
        end
      end

      it "棋譜の羅列" do
        assert { @info.move_infos.first[:input] == "７六歩(77)" }
      end

      it "最後の情報" do
        assert { @info.last_status_params[:last_action_key] == "投了" }
        assert { @info.last_status_params[:used_seconds] == 10 }
      end

      it "対局前コメント" do
        assert { @info.first_comments == ["放映日：2003/09/7", "棋戦詳細：第53回ＮＨＫ杯戦2回戦第05局", "「(先 手)七段」vs「(後手)九段」", "対局前コメント"] }
      end
    end

    it "盤面表示" do
      mediator = Mediator.start
      assert { mediator.board.to_s == <<~EOT }
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

    describe "詰将棋" do
      before do
        @info = Parser::KifParser.parse(<<~EOT)
# ----  柿木将棋VII V7.10 棋譜ファイル  ----
表題：看寿2003.DIA #56
作者：岡村孝雄
発表誌：詰パラ 2003年11月号 P.19
場所：(site)
手合割：平手　　
後手の持駒：飛二　角　銀二　桂四　香四　歩九　
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・ ・v玉|一
| ・ ・ ・ ・ ・ ・ ・ ・ ・|二
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
      end

      it do
        assert { @info.to_csa == <<~EOT }
V2.2
$SITE:(site)
P1 *  *  *  *  *  *  *  * -OU
P2 *  *  *  *  *  *  *  *  *
P3 *  *  *  *  *  *  *  *  *
P4 *  *  *  *  *  *  *  *  *
P5 *  *  *  *  *  *  *  *  *
P6 *  *  *  *  *  *  *  *  *
P7 *  *  *  *  *  *  *  *  *
P8 *  *  *  *  *  *  *  *  *
P9 *  *  *  *  *  *  *  *  *
P+00KA00KI00KI00KI00KI00GI00GI00FU00FU00FU00FU00FU00FU00FU00FU00FU
P-00HI00HI00KA00GI00GI00KE00KE00KE00KE00KY00KY00KY00KY00FU00FU00FU00FU00FU00FU00FU00FU00FU
+
+0064KA
-0053KA
%TORYO
EOT
      end

      it "マイナビのKIFでは手合割に「詰将棋」が指定されている" do
        info = Parser::KifParser.parse(<<~EOT)
手合割：詰将棋
手数----指手---------消費時間--
EOT
        assert { info.to_kif }
      end
    end

    # curl -O http://swks.sakura.ne.jp/wars/kifu/akicho8-JackTuti-20130609_201346.kif
    it "将棋ウォーズ棋譜変換サイトが生成したKIFフォーマットが読める" do
      info = Parser::KifParser.parse(Pathname(__FILE__).dirname.join("../../resources/akicho8-JackTuti-20130609_201346.kif").expand_path)
      assert { info.header }
      assert { info.move_infos }
    end

    it "ヘッダーがなくてもKIFと判定する" do
      info = Parser.parse(<<~EOT)
      1 ７六歩
      2 ３四歩
      EOT
      assert { info.class == Bioshogi::Parser::KifParser }
      assert { info.move_infos == [{turn_number: "1", input: "７六歩", clock_part: nil, used_seconds: nil}, {turn_number: "2", input: "３四歩", clock_part: nil, used_seconds: nil}] }

      info = Parser.parse("1 投了")
      assert { info.class == Bioshogi::Parser::KifParser }
      assert { info.move_infos == [] }
    end
  end
end
