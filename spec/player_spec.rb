# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Player do
    context "配置" do
      context "できる" do
        it "歩を相手の陣地に" do
          Player.this_case(:init => "5三歩").should == ["▲5三歩"]
        end
        it "成っている歩を相手の陣地に" do
          Player.this_case(:init => "5三と").should == ["▲5三と"]
        end
        it "後手が置ける" do
          Player.this_case(:init => "５五飛", :player => :white).should == ["▽5五飛↓"]
        end
      end
      context "できない" do
        it "成っている金を相手の陣地に" do
          expect { Player.this_case(:init => "5三成金").to }.to raise_error(SyntaxError)
        end
        it "すでに駒があるところに駒を配置できない" do
          expect { Player.this_case(:init => ["5三銀", "5三銀"]).to }.to raise_error(PieceAlredyExist)
        end
        it "飛車は二枚持ってないので二枚配置できない" do
          expect { Player.this_case(:init => ["5二飛", "5二飛"]) }.to raise_error(PieceNotFound)
        end
      end
    end

    describe "#setup" do
      it "初期配置" do
        board = Board.new
        players = []
        players << Player.create2(:black, board)
        players << Player.create2(:white, board)
        players.each(&:piece_plot)
        board.to_s.should == <<-FIELD.strip_heredoc
+------+------+------+------+------+------+------+------+------+----+
|    9 |    8 |    7 |    6 |    5 |    4 |    3 |    2 |    1 |    |
+------+------+------+------+------+------+------+------+------+----+
| 香↓ | 桂↓ | 銀↓ | 金↓ | 玉↓ | 金↓ | 銀↓ | 桂↓ | 香↓ | 一 |
|      | 飛↓ |      |      |      |      |      | 角↓ |      | 二 |
| 歩↓ | 歩↓ | 歩↓ | 歩↓ | 歩↓ | 歩↓ | 歩↓ | 歩↓ | 歩↓ | 三 |
|      |      |      |      |      |      |      |      |      | 四 |
|      |      |      |      |      |      |      |      |      | 五 |
|      |      |      |      |      |      |      |      |      | 六 |
| 歩   | 歩   | 歩   | 歩   | 歩   | 歩   | 歩   | 歩   | 歩   | 七 |
|      | 角   |      |      |      |      |      | 飛   |      | 八 |
| 香   | 桂   | 銀   | 金   | 玉   | 金   | 銀   | 桂   | 香   | 九 |
+------+------+------+------+------+------+------+------+------+----+
FIELD
      end
    end

    context "移動" do
      context "できる" do
        it "普通に" do
          Player.this_case(:init => "７七歩", :exec => "７六歩").should == ["▲7六歩"]
        end
        it "後手の歩を(画面上では下がることに注意)" do
          Player.this_case(:player => :white, :init => "３三歩", :exec => "３四歩").should == ["▽3四歩↓"]
        end
        it "成銀を" do
          Player.this_case(:init => "４二成銀", :exec => "３二成銀").should == ["▲3二全"]
        end
        it "龍を" do
          Player.this_case(:init => "４二龍", :exec => "３二龍").should == ["▲3二龍"]
        end
        it "駒の指定なしで動かす" do
          pending
        end
        it "推測結果が複数パターンあるけど移動元が明確であれば推測しないのでエラーにならない" do
          Player.this_case(:init => ["６九金", "４九金"], :exec => "５九金(49)").should == ["▲5九金", "▲6九金"]
        end
      end

      context "できない" do
        it "動いてないので、と思うかもしれないけど、そこに来れる駒がないので" do
          expect { Player.this_case(:init => "４二銀", :exec => "４二銀") }.to raise_error(MovableSoldierNotFound)
        end
        it "推測結果が複数パターンがあったので" do
          expect { Player.this_case(:init => ["６九金", "４九金"], :exec => "５九金") }.to raise_error(AmbiguousFormatError)
        end
        it "成っている状態から成らない状態に戻ろうとしたので" do
          expect { Player.this_case(:init => "５五龍", :exec => "５六飛") }.to raise_error(PromotedPieceToNormalPiece)
        end
        it "元の駒を明示してたとしても、成っている状態から成らない状態に戻ることは" do
          expect { Player.this_case(:init => "５五龍", :exec => "５六飛(55)") }.to raise_error(PromotedPieceToNormalPiece)
        end
      end

      context "成" do
        context "成れる" do
          it "相手陣地に入るときに成る" do
            Player.this_case(:init => "２四歩", :exec => "２三歩成").should == ["▲2三と"]
          end
          it "相手陣地から出るときに成る" do
            Player.this_case(:init => "５一飛", :exec => "５四飛成").should == ["▲5四龍"]
          end
          it "後手が相手の3段目に入ったタイミングで成る(バグっていたので消さないように)" do
            Player.this_case(:player => :white, :init => "４五桂", :exec => "５七桂成").should == ["▽5七圭↓"]
          end
        end
        context "成れない" do
          it "自分の陣地に入るタイミングでは" do
            expect { Player.this_case(:init => "５五飛", :exec => "５九飛成") }.to raise_error(NotPromotable)
          end
          it "自分の陣地から出るタイミングでも" do
            expect { Player.this_case(:init => "５九飛", :exec => "５五飛成") }.to raise_error(NotPromotable)
          end
          it "天王山から一歩動いただけじゃ" do
            expect { Player.this_case(:init => "５五飛", :exec => "５六飛成") }.to raise_error(NotPromotable)
          end
          it "すでに成っているから" do
            expect { Player.this_case(:init => "５五龍", :exec => "５一飛成") }.to raise_error(AlredyPromoted)
          end
        end
      end

      context "不成" do
        context "できる" do
          it "成と明示しなかったので" do
            Player.this_case(:init => "５五桂", :exec => "４三桂").should == ["▲4三桂"]
          end
          it "不成の指定をしたので" do
            Player.this_case(:init => "５五桂", :exec => "４三桂不成").should == ["▲4三桂"]
          end
        end
        context "できない" do
          it "移動できる見込みがないとき" do
            expect { Player.this_case(:init => "５三桂", :exec => "４一桂") }.to raise_error(NotPutInPlaceNotBeMoved)
          end
        end
      end

      context "取る" do
        context "取れる" do
          it "座標指定で" do
            frame = Frame.sit_down
            frame.players[0].initial_put_on("５六歩")
            frame.players[1].initial_put_on("５五飛")
            frame.piece_discard
            frame.players[0].execute("５五歩")
            frame.players[0].piece_names.should == ["飛"]
          end
          it "同歩で取る" do
            frame = Frame.sit_down
            frame.players[0].initial_put_on("２五歩")
            frame.players[1].initial_put_on("２三歩")
            frame.piece_discard
            frame.players[0].execute("２四歩")
            frame.players[1].execute("同 歩")
            frame.players[1].piece_names.should == ["歩"]
          end
        end
        context "取れない" do
          # MEMO: 相手がいないと同角は失敗するので「相手がいない」というエラーすることも検討
          it "一人で同を使う(同角で２五がわかった上で移動しようとしたけど自分の飛車がいるために移動できなかった)" do
            expect { Player.this_case(:init => ["２五飛", "８八角"], :exec => ["５五飛", "同角"]) }.to raise_error(MovableSoldierNotFound, /5五に移動できる角がありません/)
          end
          it "初手に同歩" do
            expect { Player.this_case(:exec => "同歩") }.to raise_error(BeforePointNotFound)
          end
        end
      end
    end

    context "打つ" do
      context "打てる" do
        it "空いているところに" do
          Player.this_case(:exec => "５五歩打").should == ["▲5五歩"]
        end

        it "「打」は曖昧なときだけ付くらしい(打がない場合、動けるのを推測で無いのを確認し、打つ)" do
          pending
          # 1. 動ける駒を探す→0件
          # 2. 持駒にその駒がある
          # 3. それを打つ
        end

        it "と金は二歩にならないので" do
          Player.this_case(:init => "５五と", :exec => "５六歩打").should == ["▲5五と", "▲5六歩"]
        end
      end

      context "打てない" do
        it "場外に" do
          expect { Player.this_case(:exec => "５十飛打") }.to raise_error(UnknownPositionName)
        end
        it "自分の駒の上に" do
          expect { Player.this_case(:init => "５五飛", :exec => "５五角打") }.to raise_error(PieceAlredyExist)
        end
        it "相手の駒の上に" do
          frame = Frame.sit_down
          frame.players[1].initial_put_on("５五飛")
          expect { frame.players[0].execute("５五角打") }.to raise_error(PieceAlredyExist)
        end
        it "卍という駒がないので" do
          expect { Player.this_case(:exec => "５五卍打") }.to raise_error(SyntaxError)
        end
        it "成った状態で" do
          expect { Player.this_case(:exec => "５五龍打") }.to raise_error(PromotedPiecePutOnError)
        end
        it "１一歩打だとそれ以上動けないので" do
          expect { Player.this_case(:exec => "１一歩打") }.to raise_error(NotPutInPlaceNotBeMoved)
        end
        it "二歩なので" do
          expect { Player.this_case(:init => "５五歩", :exec => "５九歩打") }.to raise_error(DoublePawn)
        end
      end
    end

    it "全体確認" do
      board = Board.new
      players = []
      players << Player.create2(:black, board)
      players << Player.create2(:white, board)
      players.each(&:piece_plot)
      players[0].execute("7六歩")
      players[1].execute("3四歩")
      players[0].execute("2二角成")
      players[0].pieces.collect(&:name).should == ["角"]
      board.to_s.should == <<-FIELD.strip_heredoc
+------+------+------+------+------+------+------+------+------+----+
|    9 |    8 |    7 |    6 |    5 |    4 |    3 |    2 |    1 |    |
+------+------+------+------+------+------+------+------+------+----+
| 香↓ | 桂↓ | 銀↓ | 金↓ | 玉↓ | 金↓ | 銀↓ | 桂↓ | 香↓ | 一 |
|      | 飛↓ |      |      |      |      |      | 馬   |      | 二 |
| 歩↓ | 歩↓ | 歩↓ | 歩↓ | 歩↓ | 歩↓ |      | 歩↓ | 歩↓ | 三 |
|      |      |      |      |      |      | 歩↓ |      |      | 四 |
|      |      |      |      |      |      |      |      |      | 五 |
|      |      | 歩   |      |      |      |      |      |      | 六 |
| 歩   | 歩   |      | 歩   | 歩   | 歩   | 歩   | 歩   | 歩   | 七 |
|      |      |      |      |      |      |      | 飛   |      | 八 |
| 香   | 桂   | 銀   | 金   | 玉   | 金   | 銀   | 桂   | 香   | 九 |
+------+------+------+------+------+------+------+------+------+----+
FIELD
    end

    it "指したあと前回の手を確認できる" do
      Player.this_case2(:init => "５五飛", :exec => "５一飛成").last_info_str.should == "5一飛成(55)"
      Player.this_case2(:init => "５一龍", :exec => "１一龍").last_info_str.should   == "1一龍(51)"
      Player.this_case2(:exec => "５五飛打").last_info_str.should                    == "5五飛打"
    end
  end
end
