require "spec_helper"

module Bioshogi
  describe Parser::Base do
    describe "sfen から変換" do
      it "手合割がわかる" do
        info = Parser.parse("position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1")
        assert { info.preset_info.key == :"角落ち" }
      end

      it "startpos の状態から" do
        info = Parser.parse("position startpos moves 7i6h")
        assert { info.to_sfen == "position startpos moves 7i6h" }
        assert { info.to_kif == <<~EOT }
先手の戦型：嬉野流
手合割：平手
手数----指手---------消費時間--
   1 ６八銀(79)   (00:00/00:00:00)
*▲戦型：嬉野流
   2 投了
まで1手で先手の勝ち
EOT
      end

      it "startpos の代わりに sfen で記述" do
        info = Parser.parse("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7i6h")
        assert { info.to_sfen == "position startpos moves 7i6h" }
        assert { info.to_kif == <<~EOT }
先手の戦型：嬉野流
手合割：平手
手数----指手---------消費時間--
   1 ６八銀(79)   (00:00/00:00:00)
*▲戦型：嬉野流
   2 投了
まで1手で先手の勝ち
EOT
      end

      it "盤面は平手 + 持駒あり なので省略形にならない" do
        info = Parser.parse("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d")
        assert { info.to_sfen == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d" }
        assert { info.to_kif == <<~EOT }
先手の持駒：銀
後手の持駒：銀二
先手の戦型：嬉野流
手合割：平手
手数----指手---------消費時間--
   1 ６八銀(79)   (00:00/00:00:00)
*▲戦型：嬉野流
   2 ２四銀打     (00:00/00:00:00)
   3 投了
まで2手で後手の勝ち
EOT
      end

      it "2手目から始まるSFENをKIFに変換したとき2手目から始まる→1手目から始まらないとだめ" do
        info = Parser.parse("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/2P6/PP1PPPPPP/1B5R1/LNSGKGSNL w - 2 moves 5c5d 3g3f")
        assert { info.to_kif == <<~EOT }
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
後手番
手数----指手---------消費時間--
   1 ５四歩(53)   (00:00/00:00:00)
   2 ３六歩(37)   (00:00/00:00:00)
   3 投了
まで2手で先手の勝ち
EOT
      end

      it "持ってない駒を打った場合に hard_validations 内でバリデーションするのでエラー情報に盤面が含まれている" do
        info = Parser.parse("position startpos moves B*1e")
        error = info.to_kif rescue $!
        assert { error.message.lines.first.strip == "角を打とうとしましたが角を持っていません" }
        assert { error.message.include?("手数＝0 まで") }
      end
    end
  end
end
