require "spec_helper"

RSpec.describe Bioshogi::Parser::CsaParser do
  it "持駒表記の読み取り" do
    assert { Bioshogi::Parser.parse("P+00HI").container.player_at(:black).piece_box.to_s == "飛" }
    assert { Bioshogi::Parser.parse("P+00HI00HI").container.player_at(:black).piece_box.to_s == "飛二" }
  end

  describe "表記干渉" do
    def test1(s)
      Bioshogi::Parser.parse(s) rescue $!.message
    end

    it "PI P1" do
      assert { test1("PI\nP1") == "1行表現の PI と、複数行一括表現の P1 の定義が干渉しています" }
    end
    # it "PI P+" do
    #   assert { test1("PI\nP+59OU") == "P+59OU としましたがすでに、PI か P1 表記で盤面の指定があります。無駄にややこしくなるので PI P1 P+59OU 表記を同時に使わないでください" }
    # end
    # it "P1 P+" do
    #   assert { test1("P1\nP+59OU") == "P+59OU としましたがすでに、PI か P1 表記で盤面の指定があります。無駄にややこしくなるので PI P1 P+59OU 表記を同時に使わないでください" }
    # end
  end

  describe "怪しい組み合わせからBioshogi::CSA変換" do
    it "平手と持駒" do
      Bioshogi::Parser.parse("PI\nP+00HI").to_csa == <<~EOT
        V2.2
        ' 手合割:平手
        PI
        P+00HI
        +

        %TORYO
      EOT
      end
      it "P1表記と持駒" do
        Bioshogi::Parser.parse("P1\nP+00HI").to_csa == <<~EOT
          V2.2
          P1 *  *  *  *  *  *  *  *  *
          P2 *  *  *  *  *  *  *  *  *
          P3 *  *  *  *  *  *  *  *  *
          P4 *  *  *  *  *  *  *  *  *
          P5 *  *  *  *  *  *  *  *  *
          P6 *  *  *  *  *  *  *  *  *
          P7 *  *  *  *  *  *  *  *  *
          P8 *  *  *  *  *  *  *  *  *
          P9 *  *  *  *  *  *  *  *  *
          P+00HI
          +

          %TORYO
        EOT
      end
    end

    it "打のとき持駒がなければ盤面の情報を含むエラーを出す" do
      error = Bioshogi::Parser::CsaParser.parse("P1 *,+0093KA").formatter.container rescue $!
      assert { error.message.include?("先手は角を９三に打とうとしましたが角を持っていません") }
      assert { error.message.include?("先手の持駒：なし")                         } # 盤面があるということ
    end

    it "ヘッダーのコメント内バージョンをBioshogi::CSAと間違わない" do
      assert { Bioshogi::Parser::CsaParser.accept?("# Bioshogi::Kifu for iBioshogi::Phone Bioshogi::V4.01 棋譜ファイル") == false }
    end

    it "棋譜部分のパース" do
      assert { Bioshogi::Parser::CsaParser.parse("1234FU").pi.move_infos.first[:input] == "1234FU" }
      assert { Bioshogi::Parser::CsaParser.parse("+1234FU").pi.move_infos.first[:input] == "+1234FU" }
      assert { Bioshogi::Parser::CsaParser.parse("+1234FU,T1").pi.move_infos.first == { input: "+1234FU", used_seconds: 1 } }
    end

    it "残り時間の変換" do
      info = Bioshogi::Parser.parse("V2.2\n$TIME_LIMIT: 00:00+05")
      assert { info.to_kif.include?("0分 (1手5秒)") }
      assert { info.to_csa.include?("$TIME_LIMIT:00:00+05") }
    end

    it "結果を表すキーワードをKIFに変換したときどうなるか" do
      assert { Bioshogi::Parser::CsaParser.parse("%TIME_UP").formatter.judgment_message == "まで0手で時間切れにより後手の勝ち" }
      assert { Bioshogi::Parser::CsaParser.parse("%CHUDAN").formatter.judgment_message  == nil }
      assert { Bioshogi::Parser::CsaParser.parse("%TORYO").formatter.judgment_message   == "まで0手で後手の勝ち" }
      assert { Bioshogi::Parser::CsaParser.parse("%ERROR").formatter.judgment_message   == nil }
      assert { Bioshogi::Parser::CsaParser.parse("%TSUMI").formatter.judgment_message   == "まで0手で後手の勝ち" }
    end

    it "マイナス時間を考慮する(将棋ウォーズ不具合対策)" do
      info = Bioshogi::Parser.parse(<<~EOT)
      +7776FU,T+600
      -3334FU,T-600
      EOT
      assert { info.pi.move_infos[0][:used_seconds] == 600 }
      assert { info.pi.move_infos[1][:used_seconds] == -600 }
    end

    # it "空の P+ がある場合は無視というか盤面を読み取っているのでスキップしている" do
    #   info = Bioshogi::Parser.parse(<<~EOT)
    #   V2.2
    #   N+A
    #   N-B
    #   P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
    #   P2 * -HI *  *  *  *  * -KA *
    #     P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
    #   P4 *  *  *  *  *  *  *  *  *
    #     P5 *  *  *  *  *  *  *  *  *
    #     P6 *  *  *  *  *  *  *  *  *
    #     P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
    #   P8 * +KA *  *  *  *  * +HI *
    #     P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
    #   P+
    #     P-
    #     +
    #     +7776FU,T6
    #   EOT
    #   assert { info.pi.board_source.include?("P1") }
    # end
  end
# >> Bioshogi::Coverage report generated for Bioshogi::RSpec to /Bioshogi::Users/ikeda/src/bioshogi/coverage. 7 / 15 Bioshogi::LOC (46.67%) covered.
# >> .........
# >>
# >> Bioshogi::Top 9 slowest examples (0.069 seconds, 89.9% of total time):
# >>   Bioshogi::Parser::CsaParser 持駒表記の読み取り
# >>     0.02894 seconds -:5
# >>   Bioshogi::Parser::CsaParser 結果を表すキーワードをKIFに変換したときどうなるか
# >>     0.01752 seconds -:40
# >>   Bioshogi::Parser::CsaParser 残り時間の変換
# >>     0.0166 seconds -:34
# >>   Bioshogi::Parser::CsaParser PIとP1の干渉
# >>     0.0022 seconds -:10
# >>   Bioshogi::Parser::CsaParser 打のとき持駒がなければ盤面の情報を含むエラーを出す
# >>     0.00164 seconds -:18
# >>   Bioshogi::Parser::CsaParser 空の P+ がある場合は無視というか盤面を読み取っているのでスキップしている
# >>     0.00107 seconds -:57
# >>   Bioshogi::Parser::CsaParser 棋譜部分のパース
# >>     0.0005 seconds -:28
# >>   Bioshogi::Parser::CsaParser マイナス時間を考慮する(将棋ウォーズ不具合対策)
# >>     0.00032 seconds -:48
# >>   Bioshogi::Parser::CsaParser ヘッダーのコメント内バージョンをBioshogi::CSAと間違わない
# >>     0.00022 seconds -:24
# >>
# >> Bioshogi::Finished in 0.07677 seconds (files took 1.73 seconds to load)
# >> 9 examples, 0 failures
# >>
