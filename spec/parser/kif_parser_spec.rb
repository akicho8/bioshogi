require "spec_helper"

RSpec.describe Bioshogi::Parser::KifParser do
  it "アスタリスクで始まるヘッダーはそのまま取り込む" do
    assert { Bioshogi::Parser.parse("*KEY1：value1").pi.header.to_h == { "*KEY1" => "value1" } }
  end

  it "72手目で投了する場合71手目は先手が指しているので次の手番は後手になっている←複雑なのでやらない" do
    info = Bioshogi::Parser.parse("72 投了")
    assert { info.formatter.container.turn_info.turn_offset == 0               } # 内部的には0手目
    assert { info.formatter.container.turn_info.display_turn == 0              } # 表示するなら現在71手目←やめ
    assert { info.formatter.container.turn_info.current_location.key == :black } # 手番は△←やめ
    assert { info.to_kif.include?("1 投了")                         } # KIFにしたとき復元している→しないのが正しい
  end

  it "移動元を明示したのに駒がなかったときの例外に指し手の情報が含まれている" do
    proc { Bioshogi::Parser.parse("55歩(56)").to_kif }.should raise_error(Bioshogi::PieceNotFoundOnBoard, /棋譜/)
  end

  it "残り時間の変換" do
    info = Bioshogi::Parser.parse("持ち時間：1時間01分")
    info.to_kif.include?("持ち時間：1時間01分")
    info.to_csa.include?("01:00+00")
  end

  describe "kif読み込み" do
    before do
      @info = Bioshogi::Parser::KifParser.parse(<<~EOT)
      # ----  Bioshogi::Kifu for Bioshogi::Windows Bioshogi::V6.22 棋譜ファイル  ----
      開始日時：2000/01/01 00:00:00
      終了日時：2000/01/01 01:00:00
      手合割：平手
      棋戦詳細：棋戦  詳細
      *放映日：2000-01-01
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
        @info.pi.header.to_h == {
          "開始日時" => "2000/01/01",
          "終了日時" => "2000/01/01 01:00:00",
          "手合割"   => "平手",
          "棋戦詳細" => "棋戦 詳細",
          "*放映日"  => "2000/01/01",
        }
      end
    end

    it "棋譜の羅列" do
      assert { @info.pi.move_infos.first[:input] == "７六歩(77)" }
    end

    it "最後の情報" do
      assert { @info.pi.last_action_params[:last_action_key] == "投了" }
      assert { @info.pi.last_action_params[:used_seconds] == 10 }
    end

    it "対局前コメント" do
      assert { @info.pi.first_comments == ["放映日：2000-01-01", "対局前コメント"] }
    end
  end

  it "盤面表示" do
    container = Bioshogi::Container::Basic.start
    expect(container.board.to_s).to eq(<<~EOT)
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
      @info = Bioshogi::Parser::KifParser.parse(<<~EOT)
      # ----  柿木将棋Bioshogi::VII Bioshogi::V7.10 棋譜ファイル  ----
      表題：看寿2003.Bioshogi::DIA #56
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

    it "works" do
      expect(@info.to_csa).to eq(<<~EOT)
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
      info = Bioshogi::Parser::KifParser.parse(<<~EOT)
      手合割：詰将棋
      手数----指手---------消費時間--
        EOT
      assert { info.to_kif }
    end
  end

  it "ヘッダーがなくてもKIFと判定する" do
    info = Bioshogi::Parser.parse(<<~EOT)
    1 ７六歩
    2 ３四歩
    EOT
    assert { info.class == Bioshogi::Parser::KifParser }
    assert { info.pi.move_infos == [{ turn_number: "1", input: "７六歩", clock_part: nil, used_seconds: nil }, { turn_number: "2", input: "３四歩", clock_part: nil, used_seconds: nil }] }

    info = Bioshogi::Parser.parse("1 投了")
    assert { info.class == Bioshogi::Parser::KifParser }
    assert { info.pi.move_infos == [] }
  end

  #     it "駒落ちなのに「先手の持駒」のヘッダーがある場合は変換時に削除する" do
  #       info = Bioshogi::Parser.parse(<<~EOT)
  # 後手の持駒：歩2
  #   ９ ８ ７ ６ ５ ４ ３ ２ １
  # +---------------------------+
  # |v玉v桂 ・ ・ ・ ・ ・ ・ ・|一
  # | ・ ・ ・ ・ ・ ・ ・ ・ ・|一
  # | ・ ・ ・ ・ ・ ・ ・ ・ ・|二
  # | ・ ・ ・ ・ ・ ・ ・ ・ ・|三
  # | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
  # | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
  # | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
  # | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
  # | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
  # | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
  # +---------------------------+
  # 先手の持駒：歩2
  # 手合割：二枚落ち
  # 手数----指手---------消費時間--
  #    1 △73桂
  # EOT
  #       assert { info.header_part_string.exclude?("先手の持駒") }
end
# >> Bioshogi::Coverage report generated for Bioshogi::RSpec to /Bioshogi::Users/ikeda/src/bioshogi/coverage. 7 / 15 Bioshogi::LOC (46.67%) covered.
# >> .F....F.....
# >>
# >> Bioshogi::Failures:
# >>
# >>   1) Bioshogi::Parser::KifParser 72手目で投了する場合71手目は先手が指しているので次の手番は後手になっている
# >>      Bioshogi::Failure/Bioshogi::Error: Bioshogi::Unable to find - to read failed line
# >>      Bioshogi::Test::Unit::AssertionFailedError:
# >>      # -:19:in `block (2 levels) in <# >>
# >>   2) Bioshogi::Parser::KifParser kif読み込み ヘッダー部
# >>      Bioshogi::Failure/Bioshogi::Error: Bioshogi::Unable to find - to read failed line
# >>      Bioshogi::Test::Unit::AssertionFailedError:
# >>      # -:64:in `block (3 levels) in <# >>
# >> Bioshogi::Top 10 slowest examples (0.83515 seconds, 98.9% of total time):
# >>   Bioshogi::Parser::KifParser 詰将棋
# >>     0.77011 seconds -:144
# >>   Bioshogi::Parser::KifParser 72手目で投了する場合71手目は先手が指しているので次の手番は後手になっている
# >>     0.01956 seconds -:9
# >>   Bioshogi::Parser::KifParser アスタリスクで始まるヘッダーはそのまま取り込む
# >>     0.01412 seconds -:5
# >>   Bioshogi::Parser::KifParser 残り時間の変換
# >>     0.00931 seconds -:28
# >>   Bioshogi::Parser::KifParser 詰将棋 マイナビのKIFでは手合割に「詰将棋」が指定されている
# >>     0.00881 seconds -:166
# >>   Bioshogi::Parser::KifParser 移動元を明示したのに駒がなかったときの例外に指し手の情報が含まれている
# >>     0.00632 seconds -:24
# >>   Bioshogi::Parser::KifParser 盤面表示
# >>     0.00336 seconds -:95
# >>   Bioshogi::Parser::KifParser kif読み込み ヘッダー部
# >>     0.00162 seconds -:63
# >>   Bioshogi::Parser::KifParser kif読み込み 最後の情報
# >>     0.00097 seconds -:85
# >>   Bioshogi::Parser::KifParser kif読み込み 棋譜の羅列
# >>     0.00096 seconds -:81
# >>
# >> Bioshogi::Finished in 0.84422 seconds (files took 1.6 seconds to load)
# >> 12 examples, 2 failures
# >>
# >> Bioshogi::Failed examples:
# >>
# >> rspec -:9 # Bioshogi::Parser::KifParser 72手目で投了する場合71手目は先手が指しているので次の手番は後手になっている
# >> rspec -:63 # Bioshogi::Parser::KifParser kif読み込み ヘッダー部
# >>
