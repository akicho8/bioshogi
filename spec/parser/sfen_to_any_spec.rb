require_relative "../spec_helper"

module Bushido
  describe Parser::Base do
    describe "sfen から変換" do
      it "startpos の状態から" do
        info = Parser.parse("position startpos moves 7i6h")
        info.to_sfen.should == "position startpos moves 7i6h"
        info.to_kif.should == <<~EOT
先手の囲い：
後手の囲い：
先手の戦型：嬉野流
後手の戦型：
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
        info.to_sfen.should == "position startpos moves 7i6h"
        info.to_kif.should == <<~EOT
先手の囲い：
後手の囲い：
先手の戦型：嬉野流
後手の戦型：
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
        info.to_sfen.should == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d"
        info.to_kif.should == <<~EOT
先手の持駒：銀
後手の持駒：銀二
先手の囲い：
後手の囲い：
先手の戦型：嬉野流
後手の戦型：
手合割：平手
手数----指手---------消費時間--
   1 ６八銀(79)   (00:00/00:00:00)
*▲戦型：嬉野流
   2 ２四銀打     (00:00/00:00:00)
   3 投了
まで2手で後手の勝ち
EOT
      end
    end
  end
end
