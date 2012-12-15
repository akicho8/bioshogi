# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Player do
    let(:field)  { Field.new }

    describe "#side_soldiers_put_on" do
      subject { Player.new(:black, field, :lower) }
      it "歩を相手の陣地に配置" do
        subject.initial_put_on("5三歩")
        subject.soldiers.collect(&:to_text).should == ["▲5三歩"]
      end
      it "成っている歩を相手の陣地に配置" do
        subject.initial_put_on("5三と")
        subject.soldiers.collect(&:to_text).should == ["▲5三と"]
      end
      it "成っている金を相手の陣地に配置" do
        expect { subject.initial_put_on("5三成金") }.to raise_error(SyntaxError)
      end
      it "すでに駒があるところに駒を配置できない" do
        subject.initial_put_on("5三歩")
        expect { subject.initial_put_on("5三歩") }.to raise_error(PieceAlredyExist)
      end
      it "飛車は二枚持ってないので二枚配置できない" do
        subject.initial_put_on("5二飛")
        expect { subject.initial_put_on("5二飛") }.to raise_error(PieceNotFound)
      end
    end

    describe "#setup" do
      it "初期配置" do
        players = []
        players << Player.new(:black, field, :lower)
        players << Player.new(:white, field, :upper)
        players.each(&:setup)
        field.to_s.should == <<-FIELD.strip_heredoc
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

    describe "#execute" do
      context "移動できる" do
        it "「７六歩」は７七の歩が上に上がる" do
          player = Player.new(:black, field, :lower)
          player.initial_put_on("７七歩")
          soldier = field["７七"]
          player.execute("７六歩")
          field["７六"].should == soldier
          field["７七"].should == nil
        end

        it "後手の「３四歩」は３三の歩が上に上がる(画面上で下がることに注意)" do
          player = Player.new(:white, field, :upper)
          player.initial_put_on("３三歩")
          soldier = field["３三"]
          player.execute("３四歩")
          field["３四"].should == soldier
          field["３三"].should == nil
        end

        it "成銀を動かす" do
          player = Player.new(:black, field, :lower)
          player.initial_put_on("４二成銀")
          soldier = field["４二"]
          player.execute("３二成銀")
          field["３二"].should == soldier
          field["４二"].should == nil
        end

        it "龍を動かす" do
          player = Player.new(:black, field, :lower)
          player.initial_put_on("４二龍")
          soldier = field["４二"]
          player.execute("３二龍")
          field["３二"].should == soldier
          field["４二"].should == nil
        end

        it "駒の指定なしで動かす" do
          pending
        end

        it "推測結果が複数パターンあるけど移動元が明確であれば推測しないのでエラーにならない" do
          player = Player.new(:black, field, :lower)
          player.initial_put_on("６九金")
          player.initial_put_on("４九金")
          player.execute("５九金(49)")
          field["４九"].should == nil
        end
      end

      context "移動できない" do
        it "動いてない(エラーの種類は動いてないではなくそこに来る駒がない)" do
          player = Player.new(:black, field, :lower)
          player.initial_put_on("４二銀")
          expect { player.execute("４二銀") }.to raise_error(MovableSoldierNotFound)
        end

        it "推測結果が複数パターンがあったときにエラーにする" do
          player = Player.new(:black, field, :lower)
          player.initial_put_on("６九金")
          player.initial_put_on("４九金")
          expect { player.execute("５九金") }.to raise_error(AmbiguousFormatError)
        end
      end

      context "成る" do
        let(:player) { Player.new(:black, field, :lower) }

        it "相手陣地に入るときに成る" do
          player.initial_put_on("２四歩")
          player.execute("２三歩成")
          field["２三"].promoted.should == true
        end

        it "相手陣地から出るときに成る" do
          player.initial_put_on("５一飛")
          player.execute("５四飛成")
          field["５四"].promoted.should == true
        end

        describe "成っている状態から成らない状態に戻ろうとした" do
          it "推測する場合" do
            player.initial_put_on("５五龍")
            expect { player.execute("５六飛") }.to raise_error(PromotedPieceToNormalPiece)
          end
          it "元の位置が書いてある場合" do
            player.initial_put_on("５五龍")
            expect { player.execute("５六飛(55)") }.to raise_error(PromotedPieceToNormalPiece)
          end
        end

        context "成れないシリーズ" do
          it "自分の陣地に入るタイミングでは成れない" do
            player.initial_put_on("５五飛")
            expect { player.execute("５九飛成") }.to raise_error(NotPromotable)
          end

          it "自分の陣地から出るタイミングでも成れない" do
            player.initial_put_on("５九飛")
            expect { player.execute("５五飛成") }.to raise_error(NotPromotable)
          end

          it "天王山から一歩動いても成れない" do
            player.initial_put_on("５五飛")
            expect { player.execute("５六飛成") }.to raise_error(NotPromotable)
          end

          it "すでに成っているから成れない" do
            player.initial_put_on("５五龍")
            expect { player.execute("５一飛成") }.to raise_error(AlredyPromoted)
          end
        end
      end

      context "不成" do
        let(:player) { Player.new(:black, field, :lower) }

        it "不成の指定なし" do
          player.initial_put_on("５五桂")
          player.execute("４三桂")
          field["４三"].name.should == "▲4三桂"
        end

        it "不成の指定あり" do
          player.initial_put_on("５五桂")
          player.execute("４三桂不成")
          field["４三"].name.should == "▲4三桂"
        end

        it "ぜったいに成らないといけないのでエラー" do
          player.initial_put_on("５三桂")
          expect { player.execute("４一桂") }.to raise_error(NotPutInPlaceNotBeMoved)
        end
      end

      context "取る" do
        it "相手の駒を取る" do
          player0 = Player.new(:black, field, :lower)
          player1 = Player.new(:white, field, :upper)
          player0.initial_put_on("５六歩")
          player1.initial_put_on("５五飛")
          soldier = field["５五"]
          player0.execute("５五歩")
          player0.pieces == [soldier.piece]
        end

        # MEMO: 相手がいないと絶対に「同角」は失敗するので相手がいないというエラーにした方がいいかもしれない
        it "一人で同を使う(同角で２五がわかった上で移動しようとしたけど自分の飛車がいるために移動できなかった)" do
          player = Player.new(:black, field, :lower)
          player.initial_put_on("２五飛")
          player.initial_put_on("８八角")
          player.execute("５五飛")
          expect { player.execute("同角") }.to raise_error(MovableSoldierNotFound, /5五に移動できる角がありません/)
        end

        it "同歩で取る" do
          frame = Frame.new
          frame.players << Player.new(:black, frame.field, :lower)
          frame.players << Player.new(:white, frame.field, :upper)
          frame.attach
          frame.players[0].initial_put_on("２五歩")
          frame.players[1].initial_put_on("２三歩")
          piece = frame.field["２五"].piece
          frame.players[0].execute("２四歩")
          frame.players[1].pieces.include?(piece).should == false
          frame.players[1].execute("同歩")
          frame.players[1].pieces.include?(piece).should == true
        end

        it "いきなり同歩で始まっても意味がわからない" do
          pending
        end
      end

      context "打つ" do
        let(:player) { Player.new(:black, field, :lower) }

        context "打てる" do
          it "空いているので打てる" do
            player.execute("５五歩打")
            field["５五"].name.should == "▲5五歩"
          end

          it "「打」は曖昧なときだけ付くらしい(打がない場合、動けるのを推測で無いのを確認し、打つ)" do
            pending
            # 1. 動ける駒を探す→0件
            # 2. 持駒にその駒がある
            # 3. それを打つ
          end

          it "と金は二歩にならないので" do
            player.initial_put_on("５五と")
            player.execute("５六歩打")
            field["５六"].name.should == "▲5六歩"
          end
        end

        context "打てない" do
          it "場外に" do
            expect { player.execute("５十飛打") }.to raise_error(UnknownPositionName)
          end

          it "自分の駒の上に" do
            player.initial_put_on("５五飛")
            expect { player.execute("５五角打") }.to raise_error(PieceAlredyExist)
          end

          it "相手の駒の上にも" do
            white_player = Player.new(:white, field, :upper)
            white_player.initial_put_on("５五飛")
            # expect { player.execute("５五角打") }.to raise_error(PieceAlredyExist)
          end

          it "卍なんて駒はないので" do
            expect { player.execute("５五卍打") }.to raise_error(SyntaxError)
          end

          it "成った状態で" do
            expect { player.execute("５五龍打") }.to raise_error(PromotedPiecePutOnError)
          end

          # it "１一歩打だとそれ以上動けないので" do
          #   player.execute("１一歩打")
          #   puts field
          #   # FIXME:ここのテストの処理が無限ループしている
          # end

          it "二歩なので" do
            player.initial_put_on("５五歩")
            expect { player.execute("５九歩打") }.to raise_error(DoublePawn)
          end
        end
      end

      it "全体確認" do
        players = []
        players << Player.new(:black, field, :lower)
        players << Player.new(:white, field, :upper)
        players.each(&:setup)
        players[0].execute("7六歩")
        players[1].execute("3四歩")
        players[0].execute("2二角成")
        players[0].pieces.collect(&:name).should == ["角"]
        field.to_s.should == <<-FIELD.strip_heredoc
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
    end
  end
end
