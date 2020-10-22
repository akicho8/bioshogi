require_relative "../spec_helper"

module Bioshogi
  describe Parser::CsaParser do
    it "打のとき持駒がなければ盤面の情報を含むエラーを出す" do
      error = Parser::CsaParser.parse("P1 *,+0093KA").mediator rescue $!
      assert { error.message.include?("角を打とうとしましたが角を持っていません") }
      assert { error.message.include?("先手の持駒：なし")                         } # 盤面があるということ
    end

    it "ヘッダーのコメント内バージョンをCSAと間違わない" do
      assert { Parser::CsaParser.accept?("# Kifu for iPhone V4.01 棋譜ファイル") == false }
    end

    it "棋譜部分のパース" do
      assert { Parser::CsaParser.parse("1234FU").move_infos.first[:input] == "1234FU" }
      assert { Parser::CsaParser.parse("+1234FU").move_infos.first[:input] == "+1234FU" }
      assert { Parser::CsaParser.parse("+1234FU,T1").move_infos.first == {input: "+1234FU", used_seconds: 1} }
    end

    it "残り時間の変換" do
      info = Parser.parse("V2.2\n$TIME_LIMIT: 00:00+05")
     assert { info.to_kif.include?("0分 (1手5秒)") }
     assert { info.to_csa.include?("$TIME_LIMIT:00:00+05") }
    end

    it "結果を表すキーワードをKIFに変換したときどうなるか" do
      assert { Parser::CsaParser.parse("%TIME_UP").judgment_message == "まで0手で時間切れにより後手の勝ち" }
      assert { Parser::CsaParser.parse("%CHUDAN").judgment_message  == "まで0手で切断により後手の勝ち" }
      assert { Parser::CsaParser.parse("%TORYO").judgment_message   == "まで0手で後手の勝ち" }
      assert { Parser::CsaParser.parse("%ERROR").judgment_message   == "まで0手でエラーにより後手の勝ち" }
      assert { Parser::CsaParser.parse("%TSUMI").judgment_message   == "まで0手で後手の勝ち" }
    end

    it "マイナス時間を考慮する(将棋ウォーズ不具合対策)" do
      info = Parser.parse(<<~EOT)
      +7776FU,T+600
      -3334FU,T-600
      EOT
      assert { info.move_infos[0][:used_seconds] == 600 }
      assert { info.move_infos[1][:used_seconds] == -600 }
    end

    it "空の P+ がある場合は無視というか盤面を読み取っているのでスキップしている" do
      info = Parser.parse(<<~EOT)
V2.2
N+A
N-B
P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
P2 * -HI *  *  *  *  * -KA *
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  *
P5 *  *  *  *  *  *  *  *  *
P6 *  *  *  *  *  *  *  *  *
P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
P8 * +KA *  *  *  *  * +HI *
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
P+
P-
+
+7776FU,T6
      EOT
      assert { info.board_source.include?("P1") }
    end
  end
end
