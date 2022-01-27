require "spec_helper"

module Bioshogi
  describe Parser::Base do
    it "「手合割：トンボ」では盤面を含めないと他のソフトが読み込めない" do
      info = Parser.parse("手合割：トンボ")
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
      info = Parser.parse(<<~EOT)
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
      info = Parser.parse(<<~EOT)
      手数----指手---------消費時間--
      1 ７六歩(77)   ( 0:02/00:00:02)
      2 ３四歩(33)   ( 0:02/00:00:02)
      3 反則勝ち
      EOT
      assert { info.last_action_info == nil }
      assert { info.judgment_message == nil }
      # assert { info.last_action_info.key == :TORYO }
      # assert { info.judgment_message == "*先手の手番なのに後手が投了 (将棋倶楽部24だけに存在する「反則勝ち」)" }
      assert { info.to_csa.lines.last.strip == "%TORYO" } # これは矛盾しているけどしかたない
    end

    describe "消費時間があるKIFからの変換" do
      describe "投了の部分まで時間が指定されている場合" do
        before do
          @info = Parser.parse(<<~EOT)
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
          # puts @info.to_kif
          expect(@info.to_kif).to eq(<<~EOT)
手合割：平手
先手の戦型：嬉野流
先手の備考：居飛車
後手の備考：居飛車
手数----指手---------消費時間--
   1 ６八銀(79)   (00:30/00:00:30)
*▲戦型：嬉野流
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
          @info = Parser.parse(<<~EOT)
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
          # puts @info.to_kif
          expect(@info.to_kif).to eq(<<~EOT)
手合割：平手
先手の戦型：嬉野流
先手の備考：居飛車
後手の備考：居飛車
手数----指手---------消費時間--
   1 ６八銀(79)   (00:30/00:00:30)
*▲戦型：嬉野流
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
        @info = Parser.parse(<<~EOT)
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
end
# >> Coverage report generated for RSpec to /Users/ikeda/src/bioshogi/coverage. 7 / 15 LOC (46.67%) covered.
# >> ..F....*****
# >> 
# >> Pending: (Failures listed here are expected and do not affect your suite's status)
# >> 
# >>   1) Bioshogi::Parser::Base 2手目から始まる棋譜が読めて正しく変換できる→読めてはいけないらしい to_sfen
# >>      # Temporarily skipped with xdescribe
# >>      # -:184
# >> 
# >>   2) Bioshogi::Parser::Base 2手目から始まる棋譜が読めて正しく変換できる→読めてはいけないらしい to_csa
# >>      # Temporarily skipped with xdescribe
# >>      # -:188
# >> 
# >>   3) Bioshogi::Parser::Base 2手目から始まる棋譜が読めて正しく変換できる→読めてはいけないらしい to_kif
# >>      # Temporarily skipped with xdescribe
# >>      # -:207
# >> 
# >>   4) Bioshogi::Parser::Base 2手目から始まる棋譜が読めて正しく変換できる→読めてはいけないらしい to_ki2
# >>      # Temporarily skipped with xdescribe
# >>      # -:217
# >> 
# >>   5) Bioshogi::Parser::Base 2手目から始まる棋譜が読めて正しく変換できる→読めてはいけないらしい to_bod
# >>      # Temporarily skipped with xdescribe
# >>      # -:224
# >> 
# >> Failures:
# >> 
# >>   1) Bioshogi::Parser::Base 24棋譜の「反則勝ち」問題
# >>      Failure/Error: Unable to find - to read failed line
# >> 
# >>      NoMethodError:
# >>        undefined method `key' for nil:NilClass
# >>      # -:56:in `block (3 levels) in <module:Bioshogi>'
# >>      # <internal:prelude>:137:in `__enable'
# >>      # <internal:prelude>:137:in `enable'
# >>      # <internal:prelude>:137:in `__enable'
# >>      # <internal:prelude>:137:in `enable'
# >>      # -:56:in `block (2 levels) in <module:Bioshogi>'
# >> 
# >> Top 10 slowest examples (0.90546 seconds, 99.3% of total time):
# >>   Bioshogi::Parser::Base 時間が空でも時間を出力するオプション
# >>     0.74246 seconds -:30
# >>   Bioshogi::Parser::Base 「手合割：トンボ」では盤面を含めないと他のソフトが読み込めない
# >>     0.07741 seconds -:5
# >>   Bioshogi::Parser::Base 消費時間があるKIFからの変換 投了の部分まで時間が指定がない場合 to_kif
# >>     0.03108 seconds -:137
# >>   Bioshogi::Parser::Base 消費時間があるKIFからの変換 投了の部分まで時間が指定されている場合 to_csa
# >>     0.02041 seconds -:75
# >>   Bioshogi::Parser::Base 消費時間があるKIFからの変換 投了の部分まで時間が指定されている場合 to_kif
# >>     0.01509 seconds -:89
# >>   Bioshogi::Parser::Base 消費時間があるKIFからの変換 投了の部分まで時間が指定がない場合 to_csa
# >>     0.01385 seconds -:123
# >>   Bioshogi::Parser::Base 24棋譜の「反則勝ち」問題
# >>     0.00514 seconds -:45
# >>   Bioshogi::Parser::Base 2手目から始まる棋譜が読めて正しく変換できる→読めてはいけないらしい to_sfen
# >>     0.00001 seconds -:184
# >>   Bioshogi::Parser::Base 2手目から始まる棋譜が読めて正しく変換できる→読めてはいけないらしい to_csa
# >>     0.00001 seconds -:188
# >>   Bioshogi::Parser::Base 2手目から始まる棋譜が読めて正しく変換できる→読めてはいけないらしい to_kif
# >>     0 seconds -:207
# >> 
# >> Finished in 0.91151 seconds (files took 1.69 seconds to load)
# >> 12 examples, 1 failure, 5 pending
# >> 
# >> Failed examples:
# >> 
# >> rspec -:45 # Bioshogi::Parser::Base 24棋譜の「反則勝ち」問題
# >> 
