require "spec_helper"

RSpec.describe Bioshogi::Parser::Base do
  it "「手合割：トンボ」では盤面を含めないと他のソフトが読み込めない" do
    info = Bioshogi::Parser.parse("手合割：トンボ")
    expect(info.to_kif).to eq(<<~EOT)
    手合割：トンボ
    上手の持駒：なし
      ９ ８ ７ ６ ５ ４ ３ ２ １
    +---------------------------+
    | ・ ・ ・ ・v玉 ・ ・ ・ ・|一
    | ・v飛 ・ ・ ・ ・ ・v角 ・|二
    |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
    | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
    | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
    | 香 桂 銀 金 玉 金 銀 桂 香|九
    +---------------------------+
    下手の持駒：なし
    上手番
    手数----指手---------消費時間--
       1 投了
    まで0手で下手の勝ち
    EOT
  end

  it "時間が空でも時間を出力するオプション" do
    info = Bioshogi::Parser.parse(<<~EOT)
    手数----指手---------消費時間--
       1 ７六歩(77)  (00:00/00:00:00)
       2 投了        (00:00/00:00:00)
    EOT
    expect(info.to_kif(time_embed_force: true)).to eq(<<~EOT)
    手合割：平手
    手数----指手---------消費時間--
       1 ７六歩(77)   (00:00/00:00:00)
       2 投了         (00:00/00:00:00)
    まで1手で先手の勝ち
    EOT
  end

  it "24棋譜の「反則勝ち」問題" do
    info = Bioshogi::Parser.parse(<<~EOT)
    手数----指手---------消費時間--
       1 ７六歩(77)   ( 0:02/00:00:02)
       2 ３四歩(33)   ( 0:02/00:00:02)
       3 反則勝ち
    EOT
    assert { info.formatter.last_action_info == nil }
    assert { info.formatter.judgment_message == nil }
    # assert { info.last_action_info.key == :TORYO }
    # assert { info.judgment_message == "*先手の手番なのに後手が投了 (将棋倶楽部24だけに存在する「反則勝ち」)" }
    assert { info.to_csa.lines.last.strip == "%TORYO" } # これは矛盾しているけどしかたない
  end

  describe "消費時間があるKIFからの変換" do
    describe "投了の部分まで時間が指定されている場合" do
      before do
        @info = Bioshogi::Parser.parse(<<~EOT)
        手合割：平手
        手数----指手---------消費時間--
           1 ６八銀(79)   (00:30/00:00:30)
           2 ３四歩(33)   (00:01/00:00:01)
           3 ２六歩(27)   (00:00/00:00:30)
           4 ８四歩(83)   (00:02/00:00:03)
           5 投了         (00:01/00:00:31)
        EOT
      end

      it "to_csa" do
        expect(@info.to_csa).to eq(<<~EOT)
V2.2
' 手合割:平手
PI
+
+7968GI,T30
-3334FU,T1
+2726FU,T0
-8384FU,T2
%TORYO,T1
EOT
        end

        it "to_kif" do
          expect(@info.to_kif).to eq(<<~EOT)
手合割：平手
先手の戦法：嬉野流
先手の備考：居飛車, 相居飛車, 対居飛車
後手の備考：居飛車, 相居飛車, 対居飛車
先手の棋風：王道
手数----指手---------消費時間--
   1 ６八銀(79)   (00:30/00:00:30)
*▲戦法：嬉野流
   2 ３四歩(33)   (00:01/00:00:01)
   3 ２六歩(27)   (00:00/00:00:30)
*▲備考：居飛車
   4 ８四歩(83)   (00:02/00:00:03)
*△備考：居飛車
   5 投了         (00:01/00:00:31)
まで4手で後手の勝ち
EOT
        end
      end

      describe "投了の部分まで時間が指定がない場合" do
        before do
          @info = Bioshogi::Parser.parse(<<~EOT)
          手合割：平手
          手数----指手---------消費時間--
             1 ６八銀(79)   (00:30/00:00:30)
             2 ３四歩(33)   (00:01/00:00:01)
             3 ２六歩(27)   (00:00/00:00:30)
             4 ８四歩(83)   (00:02/00:00:03)
             5 投了
          EOT
        end

        it "to_csa" do
          expect(@info.to_csa).to eq(<<~EOT)
V2.2
' 手合割:平手
PI
+
+7968GI,T30
-3334FU,T1
+2726FU,T0
-8384FU,T2
%TORYO
EOT
      end

      it "to_kif" do
        expect(@info.to_kif).to eq(<<~EOT)
        手合割：平手
        先手の戦法：嬉野流
        先手の備考：居飛車, 相居飛車, 対居飛車
        後手の備考：居飛車, 相居飛車, 対居飛車
        先手の棋風：王道
        手数----指手---------消費時間--
           1 ６八銀(79)   (00:30/00:00:30)
        *▲戦法：嬉野流
           2 ３四歩(33)   (00:01/00:00:01)
           3 ２六歩(27)   (00:00/00:00:30)
        *▲備考：居飛車
           4 ８四歩(83)   (00:02/00:00:03)
        *△備考：居飛車
           5 投了
        まで4手で後手の勝ち
        EOT
      end
    end
  end

  xdescribe "2手目から始まる棋譜が読めて正しく変換できる→読めてはいけないらしい" do
    before do
      @info = Bioshogi::Parser.parse(<<~EOT)
      後手の持駒：なし
        ９ ８ ７ ６ ５ ４ ３ ２ １
      +---------------------------+
        |v香v桂v銀v金v玉v金v銀v桂v香|一
    | ・v飛 ・ ・ ・ ・ ・v角 ・|二
    |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
    | ・ ・ 歩 ・ ・ ・ ・ ・ ・|六
    | 歩 歩 ・ 歩 歩 歩 歩 歩 歩|七
    | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
    | 香 桂 銀 金 玉 金 銀 桂 香|九
      +---------------------------+
        先手の持駒：なし
      手数----指手---------消費時間--
        2 ５四歩(53)   (00:00/00:00:00)
      3 ３六歩(37)   (00:00/00:00:00)
      4 投了
      まで5手で先手の勝ち
      EOT
    end

    it "to_sfen" do
      assert { @info.to_sfen == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/2P6/PP1PPPPPP/1B5R1/LNSGKGSNL w - 2 moves 5c5d 3g3f" }
    end

    it "to_csa" do
      expect(@info.to_csa(has_header: false)).to eq(<<~EOT)
      V2.2
      P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
      P2 * -HI *  *  *  *  * -KA *
        P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
      P4 *  *  *  *  *  *  *  *  *
        P5 *  *  *  *  *  *  *  *  *
        P6 *  * +FU *  *  *  *  *  *
        P7+FU+FU * +FU+FU+FU+FU+FU+FU
      P8 * +KA *  *  *  *  * +HI *
        P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
      -
        -5354FU
      +3736FU
      %TORYO
      EOT
    end

    it "to_kif" do
      expect(@info.to_kif(has_header: false)).to eq(<<~EOT)
      手数----指手---------消費時間--
        1 ５四歩(53)
      2 ３六歩(37)
      3 投了
      まで2手で先手の勝ち
      EOT
    end

    it "to_ki2" do
      expect(@info.to_ki2(has_header: false)).to eq(<<~EOT)
      △５四歩 ▲３六歩
      まで2手で先手の勝ち
      EOT
    end

    it "to_bod" do
      expect(@info.to_bod).to eq(<<~EOT)
      後手の持駒：なし
        ９ ８ ７ ６ ５ ４ ３ ２ １
      +---------------------------+
        |v香v桂v銀v金v玉v金v銀v桂v香|一
    | ・v飛 ・ ・ ・ ・ ・v角 ・|二
    |v歩v歩v歩v歩 ・v歩v歩v歩v歩|三
    | ・ ・ ・ ・v歩 ・ ・ ・ ・|四
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
    | ・ ・ 歩 ・ ・ ・ 歩 ・ ・|六
    | 歩 歩 ・ 歩 歩 歩 ・ 歩 歩|七
    | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
    | 香 桂 銀 金 玉 金 銀 桂 香|九
      +---------------------------+
        先手の持駒：なし
      手数＝3 ▲３六歩(37) まで

      後手番
      EOT
    end
  end
end
# >> Bioshogi::Coverage report generated for Bioshogi::RSpec to /Bioshogi::Users/ikeda/src/bioshogi/coverage. 5 / 13 Bioshogi::LOC (38.46%) covered.
# >> Bioshogi::FF..F.F*****
# >>
# >> Bioshogi::Pending: (Bioshogi::Failures listed here are expected and do not affect your suite's status)
# >>
# >>   1) Bioshogi::Parser::Base 2手目から始まる棋譜が読めて正しく変換できる→読めてはいけないらしい to_sfen
# >>      # Bioshogi::Temporarily skipped with xdescribe
# >>      # -:186
# >>
# >>   2) Bioshogi::Parser::Base 2手目から始まる棋譜が読めて正しく変換できる→読めてはいけないらしい to_csa
# >>      # Bioshogi::Temporarily skipped with xdescribe
# >>      # -:190
# >>
# >>   3) Bioshogi::Parser::Base 2手目から始まる棋譜が読めて正しく変換できる→読めてはいけないらしい to_kif
# >>      # Bioshogi::Temporarily skipped with xdescribe
# >>      # -:209
# >>
# >>   4) Bioshogi::Parser::Base 2手目から始まる棋譜が読めて正しく変換できる→読めてはいけないらしい to_ki2
# >>      # Bioshogi::Temporarily skipped with xdescribe
# >>      # -:219
# >>
# >>   5) Bioshogi::Parser::Base 2手目から始まる棋譜が読めて正しく変換できる→読めてはいけないらしい to_bod
# >>      # Bioshogi::Temporarily skipped with xdescribe
# >>      # -:226
# >>
# >> Bioshogi::Failures:
# >>
# >>   1) Bioshogi::Parser::Base 「手合割：トンボ」では盤面を含めないと他のソフトが読み込めない
# >>      Bioshogi::Failure/Bioshogi::Error: Bioshogi::Unable to find - to read failed line
# >>
# >>        expected: "手合割：トンボ\n下手の備考：居飛車, 相居飛車, 対居飛車\n上手の備考：居飛車, 相居飛車, 対居飛車\n上手の持駒：なし\n  ９ ８ ７ ６ ５ ４ ３ ２ １\n+-------------...桂 香|九\n+---------------------------+\n下手の持駒：なし\n上手番\n手数----指手---------消費時間--\n   1 投了\nまで0手で下手の勝ち\n"
# >>             got: "手合割：トンボ\n下手の備考：居飛車, 相居飛車\n上手の備考：居飛車, 相居飛車\n上手の持駒：なし\n  ９ ８ ７ ６ ５ ４ ３ ２ １\n+-------------------------...桂 香|九\n+---------------------------+\n下手の持駒：なし\n上手番\n手数----指手---------消費時間--\n   1 投了\nまで0手で下手の勝ち\n"
# >>
# >>        (compared using ==)
# >>
# >>        Bioshogi::Diff:
# >>        @@ -1,6 +1,6 @@
# >>         手合割：トンボ
# >>        -下手の備考：居飛車, 相居飛車, 対居飛車
# >>        -上手の備考：居飛車, 相居飛車, 対居飛車
# >>        +下手の備考：居飛車, 相居飛車
# >>        +上手の備考：居飛車, 相居飛車
# >>         上手の持駒：なし
# >>             ９ ８ ７ ６ ５ ４ ３ ２ １
# >>         +---------------------------+
# >>      # -:7:in `block (2 levels) in <# >>
# >>   2) Bioshogi::Parser::Base 時間が空でも時間を出力するオプション
# >>      Bioshogi::Failure/Bioshogi::Error: Bioshogi::Unable to find - to read failed line
# >>
# >>        expected: "先手の備考：居飛車, 相居飛車, 対居飛車\n後手の備考：居飛車, 相居飛車, 対居飛車\n手合割：平手\n手数----指手---------消費時間--\n   1 ７六歩(77)   (00:00/00:00:00)\n   2 投了         (00:00/00:00:00)\nまで1手で先手の勝ち\n"
# >>             got: "先手の備考：居飛車, 相居飛車\n後手の備考：居飛車, 相居飛車\n手合割：平手\n手数----指手---------消費時間--\n   1 ７六歩(77)   (00:00/00:00:00)\n   2 投了         (00:00/00:00:00)\nまで1手で先手の勝ち\n"
# >>
# >>        (compared using ==)
# >>
# >>        Bioshogi::Diff:
# >>        @@ -1,5 +1,5 @@
# >>        -先手の備考：居飛車, 相居飛車, 対居飛車
# >>        -後手の備考：居飛車, 相居飛車, 対居飛車
# >>        +先手の備考：居飛車, 相居飛車
# >>        +後手の備考：居飛車, 相居飛車
# >>         手合割：平手
# >>         手数----指手---------消費時間--
# >>            1 ７六歩(77)   (00:00/00:00:00)
# >>      # -:38:in `block (2 levels) in <# >>
# >>   3) Bioshogi::Parser::Base 消費時間があるKIFからの変換 投了の部分まで時間が指定されている場合 to_kif
# >>      Bioshogi::Failure/Bioshogi::Error: Bioshogi::Unable to find - to read failed line
# >>
# >>        expected: "手合割：平手\n先手の戦法：嬉野流\n先手の備考：居飛車, 相居飛車, 対居飛車\n後手の備考：居飛車, 相居飛車, 対居飛車\n手数----指手---------消費時間--\n   1 ６八銀(7...*▲備考：居飛車\n   4 ８四歩(83)   (00:02/00:00:03)\n*△備考：居飛車\n   5 投了         (00:01/00:00:31)\nまで4手で後手の勝ち\n"
# >>             got: "手合割：平手\n先手の戦法：嬉野流\n先手の備考：居飛車, 相居飛車\n後手の備考：居飛車, 相居飛車\n手数----指手---------消費時間--\n   1 ６八銀(79)   (00:30/...*▲備考：居飛車\n   4 ８四歩(83)   (00:02/00:00:03)\n*△備考：居飛車\n   5 投了         (00:01/00:00:31)\nまで4手で後手の勝ち\n"
# >>
# >>        (compared using ==)
# >>
# >>        Bioshogi::Diff:
# >>        @@ -1,7 +1,7 @@
# >>         手合割：平手
# >>         先手の戦法：嬉野流
# >>        -先手の備考：居飛車, 相居飛車, 対居飛車
# >>        -後手の備考：居飛車, 相居飛車, 対居飛車
# >>        +先手の備考：居飛車, 相居飛車
# >>        +後手の備考：居飛車, 相居飛車
# >>         手数----指手---------消費時間--
# >>            1 ６八銀(79)   (00:30/00:00:30)
# >>         *▲戦法：嬉野流
# >>      # -:93:in `block (4 levels) in <# >>
# >>   4) Bioshogi::Parser::Base 消費時間があるKIFからの変換 投了の部分まで時間が指定がない場合 to_kif
# >>      Bioshogi::Failure/Bioshogi::Error: Bioshogi::Unable to find - to read failed line
# >>
# >>        expected: "手合割：平手\n先手の戦法：嬉野流\n先手の備考：居飛車, 相居飛車, 対居飛車\n後手の備考：居飛車, 相居飛車, 対居飛車\n手数----指手---------消費時間--\n   1 ６八銀(7...(27)   (00:00/00:00:30)\n*▲備考：居飛車\n   4 ８四歩(83)   (00:02/00:00:03)\n*△備考：居飛車\n   5 投了\nまで4手で後手の勝ち\n"
# >>             got: "手合割：平手\n先手の戦法：嬉野流\n先手の備考：居飛車, 相居飛車\n後手の備考：居飛車, 相居飛車\n手数----指手---------消費時間--\n   1 ６八銀(79)   (00:30/...(27)   (00:00/00:00:30)\n*▲備考：居飛車\n   4 ８四歩(83)   (00:02/00:00:03)\n*△備考：居飛車\n   5 投了\nまで4手で後手の勝ち\n"
# >>
# >>        (compared using ==)
# >>
# >>        Bioshogi::Diff:
# >>        @@ -1,7 +1,7 @@
# >>         手合割：平手
# >>         先手の戦法：嬉野流
# >>        -先手の備考：居飛車, 相居飛車, 対居飛車
# >>        -後手の備考：居飛車, 相居飛車, 対居飛車
# >>        +先手の備考：居飛車, 相居飛車
# >>        +後手の備考：居飛車, 相居飛車
# >>         手数----指手---------消費時間--
# >>            1 ６八銀(79)   (00:30/00:00:30)
# >>         *▲戦法：嬉野流
# >>      # -:141:in `block (4 levels) in <# >>
# >> Bioshogi::Top 10 slowest examples (0.18518 seconds, 94.4% of total time):
# >>   Bioshogi::Parser::Base 時間が空でも時間を出力するオプション
# >>     0.10126 seconds -:32
# >>   Bioshogi::Parser::Base 「手合割：トンボ」では盤面を含めないと他のソフトが読み込めない
# >>     0.03588 seconds -:5
# >>   Bioshogi::Parser::Base 24棋譜の「反則勝ち」問題
# >>     0.03121 seconds -:49
# >>   Bioshogi::Parser::Base 消費時間があるKIFからの変換 投了の部分まで時間が指定されている場合 to_csa
# >>     0.00582 seconds -:77
# >>   Bioshogi::Parser::Base 消費時間があるKIFからの変換 投了の部分まで時間が指定されている場合 to_kif
# >>     0.00419 seconds -:91
# >>   Bioshogi::Parser::Base 消費時間があるKIFからの変換 投了の部分まで時間が指定がない場合 to_kif
# >>     0.00355 seconds -:139
# >>   Bioshogi::Parser::Base 消費時間があるKIFからの変換 投了の部分まで時間が指定がない場合 to_csa
# >>     0.00325 seconds -:125
# >>   Bioshogi::Parser::Base 2手目から始まる棋譜が読めて正しく変換できる→読めてはいけないらしい to_sfen
# >>     0.00001 seconds -:186
# >>   Bioshogi::Parser::Base 2手目から始まる棋譜が読めて正しく変換できる→読めてはいけないらしい to_csa
# >>     0.00001 seconds -:190
# >>   Bioshogi::Parser::Base 2手目から始まる棋譜が読めて正しく変換できる→読めてはいけないらしい to_kif
# >>     0 seconds -:209
# >>
# >> Bioshogi::Finished in 0.19616 seconds (files took 1.98 seconds to load)
# >> 12 examples, 4 failures, 5 pending
# >>
# >> Bioshogi::Failed examples:
# >>
# >> rspec -:5 # Bioshogi::Parser::Base 「手合割：トンボ」では盤面を含めないと他のソフトが読み込めない
# >> rspec -:32 # Bioshogi::Parser::Base 時間が空でも時間を出力するオプション
# >> rspec -:91 # Bioshogi::Parser::Base 消費時間があるKIFからの変換 投了の部分まで時間が指定されている場合 to_kif
# >> rspec -:139 # Bioshogi::Parser::Base 消費時間があるKIFからの変換 投了の部分まで時間が指定がない場合 to_kif
# >>
