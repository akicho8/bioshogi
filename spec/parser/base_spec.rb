require "spec_helper"

module Bioshogi
  RSpec.describe Parser::Base do
    describe "「上手の持駒：なし」があって手合割がわかっているときは「上手の持駒」の部分は消しとく" do
      before do
        @info = Parser.parse(<<~EOT)
手合割：三枚落ち
上手：伊藤宗印
上手の持駒：なし
下手の持駒：
下手：天満屋
手数----指手---------消費時間--
   1 ６二銀(71)   (00:00/00:00:00)
EOT
      end

      it "to_kif" do
        expect(@info.to_kif).to eq(<<~EOT)
手合割：三枚落ち
上手：伊藤宗印
下手：天満屋
手数----指手---------消費時間--
   1 ６二銀(71)
   2 投了
まで1手で上手の勝ち
EOT
      end
    end

    describe "手合割が「三枚落ち」で図が指定されている場合" do
      before do
        @info = Parser.parse(<<~EOT)
手合割：三枚落ち
上手：伊藤宗印
上手の持駒：なし
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金v銀v桂 ・|一
| ・ ・ ・ ・ ・ ・ ・ ・ ・|二
|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 銀 桂 香|九
+---------------------------+
下手の持駒：なし
下手：天満屋

△６二銀
        EOT
      end

      it "to_csa" do
        expect(@info.to_csa).to eq(<<~EOT)
V2.2
' 手合割:三枚落ち
P1-KY-KE-GI-KI-OU-KI-GI-KE *
P2 *  *  *  *  *  *  *  *  *
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  *
P5 *  *  *  *  *  *  *  *  *
P6 *  *  *  *  *  *  *  *  *
P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
P8 * +KA *  *  *  *  * +HI *
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
-
-7162GI
%TORYO
EOT
      end

      it "to_kif" do
        expect(@info.to_kif).to eq(<<~EOT)
手合割：三枚落ち
上手：伊藤宗印
下手：天満屋
手数----指手---------消費時間--
   1 ６二銀(71)
   2 投了
まで1手で上手の勝ち
EOT
      end
    end

    describe "手合割が「その他」で図が指定されている場合は一応駒落ちになる" do
      before do
        @info = Parser.parse(<<~EOT)
手合割：その他
上手の持駒：なし
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金 ・v桂v香|一
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

△８四歩
        EOT
      end

      xit "to_kif" do
        expect(@info.to_kif).to eq(<<~EOT)
手合割：その他
上手の備考：居飛車
上手の持駒：なし
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金 ・v桂v香|一
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
   1 ８四歩(83)
*△備考：居飛車
   2 投了
まで1手で上手の勝ち
EOT
      end

      it "to_kif" do
        expect { @info.to_kif }.to raise_error(DifferentTurnCommonError, /【反則】先手の手番で後手が着手しました/)
      end

      xit "to_csa" do
        expect(@info.to_csa).to eq(<<~EOT)
V2.2
P1-KY-KE-GI-KI-OU-KI * -KE-KY
P2 * -HI *  *  *  *  * -KA *
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  *
P5 *  *  *  *  *  *  *  *  *
P6 *  *  *  *  *  *  *  *  *
P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
P8 * +KA *  *  *  *  * +HI *
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
-
-8384FU
%TORYO
EOT
      end
    end
  end
end
# >> Coverage report generated for RSpec to /Users/ikeda/src/bioshogi/coverage. 7 / 15 LOC (46.67%) covered.
# >> ...FF
# >>
# >> Failures:
# >>
# >>   1) Bioshogi::Parser::Base 手合割が「その他」で図が指定されている場合は一応駒落ちになる to_kif
# >>      Failure/Error: raise obj
# >>
# >>      Bioshogi::DifferentTurnCommonError:
# >>        【反則】先手の手番で後手が着手しました
# >>        手番: 先手
# >>        指し手: △８四歩
# >>        棋譜:
# >>
# >>        後手の持駒：なし
# >>          ９ ８ ７ ６ ５ ４ ３ ２ １
# >>        +---------------------------+
# >>        |v香v桂v銀v金v玉v金 ・v桂v香|一
# >>        | ・v飛 ・ ・ ・ ・ ・v角 ・|二
# >>        |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# >>        | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >>        | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >>        | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >>        | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
# >>        | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
# >>        | 香 桂 銀 金 玉 金 銀 桂 香|九
# >>        +---------------------------+
# >>        先手の持駒：なし
# >>        手数＝0 まで
# >>
# >>        先手番
# >>      # ./lib/bioshogi/player_executor_base.rb:131:in `raise_error'
# >>      # ./lib/bioshogi/player_executor_base.rb:37:in `perform_validations'
# >>      # ./lib/bioshogi/player_executor_base.rb:42:in `execute'
# >>      # ./lib/bioshogi/player.rb:23:in `execute'
# >>      # ./lib/bioshogi/container_executor.rb:31:in `block in execute'
# >>      # ./lib/bioshogi/container_executor.rb:30:in `each'
# >>      # ./lib/bioshogi/container_executor.rb:30:in `execute'
# >>      # ./lib/bioshogi/formatter/parser_methods.rb:276:in `block in container_run_all'
# >>      # ./lib/bioshogi/formatter/parser_methods.rb:266:in `each'
# >>      # ./lib/bioshogi/formatter/parser_methods.rb:266:in `with_index'
# >>      # ./lib/bioshogi/formatter/parser_methods.rb:266:in `container_run_all'
# >>      # ./lib/bioshogi/formatter/parser_methods.rb:49:in `block in container'
# >>      # ./lib/bioshogi/formatter/parser_methods.rb:47:in `tap'
# >>      # ./lib/bioshogi/formatter/parser_methods.rb:47:in `container'
# >>      # ./lib/bioshogi/formatter/parser_methods.rb:13:in `formatter.container_run_once'
# >>      # ./lib/bioshogi/kif_builder.rb:24:in `to_s'
# >>      # ./lib/bioshogi/formatter/parser_methods.rb:501:in `to_kif'
# >>      # -:112:in `block (3 levels) in <module:Bioshogi>'
# >>
# >>   2) Bioshogi::Parser::Base 手合割が「その他」で図が指定されている場合は一応駒落ちになる to_csa
# >>      Failure/Error: raise obj
# >>
# >>      Bioshogi::DifferentTurnCommonError:
# >>        【反則】先手の手番で後手が着手しました
# >>        手番: 先手
# >>        指し手: △８四歩
# >>        棋譜:
# >>
# >>        後手の持駒：なし
# >>          ９ ８ ７ ６ ５ ４ ３ ２ １
# >>        +---------------------------+
# >>        |v香v桂v銀v金v玉v金 ・v桂v香|一
# >>        | ・v飛 ・ ・ ・ ・ ・v角 ・|二
# >>        |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# >>        | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >>        | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >>        | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >>        | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
# >>        | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
# >>        | 香 桂 銀 金 玉 金 銀 桂 香|九
# >>        +---------------------------+
# >>        先手の持駒：なし
# >>        手数＝0 まで
# >>
# >>        先手番
# >>      # ./lib/bioshogi/player_executor_base.rb:131:in `raise_error'
# >>      # ./lib/bioshogi/player_executor_base.rb:37:in `perform_validations'
# >>      # ./lib/bioshogi/player_executor_base.rb:42:in `execute'
# >>      # ./lib/bioshogi/player.rb:23:in `execute'
# >>      # ./lib/bioshogi/container_executor.rb:31:in `block in execute'
# >>      # ./lib/bioshogi/container_executor.rb:30:in `each'
# >>      # ./lib/bioshogi/container_executor.rb:30:in `execute'
# >>      # ./lib/bioshogi/formatter/parser_methods.rb:276:in `block in container_run_all'
# >>      # ./lib/bioshogi/formatter/parser_methods.rb:266:in `each'
# >>      # ./lib/bioshogi/formatter/parser_methods.rb:266:in `with_index'
# >>      # ./lib/bioshogi/formatter/parser_methods.rb:266:in `container_run_all'
# >>      # ./lib/bioshogi/formatter/parser_methods.rb:49:in `block in container'
# >>      # ./lib/bioshogi/formatter/parser_methods.rb:47:in `tap'
# >>      # ./lib/bioshogi/formatter/parser_methods.rb:47:in `container'
# >>      # ./lib/bioshogi/formatter/parser_methods.rb:13:in `formatter.container_run_once'
# >>      # ./lib/bioshogi/csa_builder.rb:50:in `to_s'
# >>      # ./lib/bioshogi/formatter/parser_methods.rb:509:in `to_csa'
# >>      # -:140:in `block (4 levels) in <module:Bioshogi>'
# >>      # <internal:prelude>:137:in `__enable'
# >>      # <internal:prelude>:137:in `enable'
# >>      # <internal:prelude>:137:in `__enable'
# >>      # <internal:prelude>:137:in `enable'
# >>      # -:140:in `block (3 levels) in <module:Bioshogi>'
# >>
# >> Top 5 slowest examples (0.8072 seconds, 99.2% of total time):
# >>   Bioshogi::Parser::Base 「上手の持駒：なし」があって手合割がわかっているときは「上手の持駒」の部分は消しとく to_kif
# >>     0.75513 seconds -:18
# >>   Bioshogi::Parser::Base 手合割が「三枚落ち」で図が指定されている場合 to_csa
# >>     0.01882 seconds -:56
# >>   Bioshogi::Parser::Base 手合割が「三枚落ち」で図が指定されている場合 to_kif
# >>     0.01712 seconds -:75
# >>   Bioshogi::Parser::Base 手合割が「その他」で図が指定されている場合は一応駒落ちになる to_csa
# >>     0.01103 seconds -:139
# >>   Bioshogi::Parser::Base 手合割が「その他」で図が指定されている場合は一応駒落ちになる to_kif
# >>     0.0051 seconds -:111
# >>
# >> Finished in 0.81364 seconds (files took 1.63 seconds to load)
# >> 5 examples, 2 failures
# >>
# >> Failed examples:
# >>
# >> rspec -:111 # Bioshogi::Parser::Base 手合割が「その他」で図が指定されている場合は一応駒落ちになる to_kif
# >> rspec -:139 # Bioshogi::Parser::Base 手合割が「その他」で図が指定されている場合は一応駒落ちになる to_csa
# >>
