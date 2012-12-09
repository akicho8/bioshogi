# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Player do
    let(:field)  { Field.new }

    describe "#side_soldiers_put_on" do
      subject { Player.new("先手", field, :lower) }
      it "歩を相手の陣地に配置" do
        subject.initial_put_on("5三歩")
        subject.soldiers.collect(&:to_text).should == ["▲5三歩"]
      end
      it "成っている歩を相手の陣地に配置" do
        subject.initial_put_on("5三と")
        subject.soldiers.collect(&:to_text).should == ["▲5三と"]
      end
      it "成っている金を相手の陣地に配置" do
        proc { subject.initial_put_on("5三成金") }.should raise_error(SyntaxError)
      end
      it "すでに駒があるところに駒を配置できない" do
        subject.initial_put_on("5三歩")
        proc { subject.initial_put_on("5三歩") }.should raise_error(PieceAlredyExist)
      end
      it "飛車は二枚持ってないので二枚配置できない" do
        subject.initial_put_on("5二飛")
        proc { subject.initial_put_on("5二飛") }.should raise_error(PieceNotFound)
      end
    end

    describe "#setup" do
      it "初期配置" do
        players = []
        players << Player.new("先手", field, :lower)
        players << Player.new("後手", field, :upper)
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
      context "移動" do
        it "「７六歩」は７七の歩が上に上がる" do
          player = Player.new("先手", field, :lower)
          player.initial_put_on("７七歩")
          soldier = field["７七"]
          player.execute("７六歩")
          field["７六"].should == soldier
          field["７七"].should == nil
        end

        it "後手の「３四歩」は３三の歩が上に上がる(画面上で下がることに注意)" do
          player = Player.new("後手", field, :upper)
          player.initial_put_on("３三歩")
          soldier = field["３三"]
          player.execute("３四歩")
          field["３四"].should == soldier
          field["３三"].should == nil
        end

        it "成銀を動かす" do
          player = Player.new("先手", field, :lower)
          player.initial_put_on("４二成銀")
          soldier = field["４二"]
          player.execute("３二成銀")
          field["３二"].should == soldier
          field["４二"].should == nil
        end

        it "龍を動かす" do
          player = Player.new("先手", field, :lower)
          player.initial_put_on("４二龍")
          soldier = field["４二"]
          player.execute("３二龍")
          field["３二"].should == soldier
          field["４二"].should == nil
        end

        it "駒の指定なしで動かす" do
          pending
        end

        it "動いてない(エラーの種類は動いてないではなくそこに来る駒がない)" do
          player = Player.new("先手", field, :lower)
          player.initial_put_on("４二銀")
          proc { player.execute("４二銀") }.should raise_error(MovableSoldierNotFound)
        end

        context "推測結果が複数パターンがあったときにエラーにする" do
          it do
            player = Player.new("先手", field, :lower)
            player.initial_put_on("６九金")
            player.initial_put_on("４九金")
            proc { player.execute("５九金") }.should raise_error(AmbiguousFormatError)
          end
        end

        context "推測結果が複数パターンあるけど移動元が明確であれば推測しないのでエラーにならない" do
          it do
            player = Player.new("先手", field, :lower)
            player.initial_put_on("６九金")
            player.initial_put_on("４九金")
            player.execute("５九金(49)")
            field["４九"].should == nil
          end
        end
      end

      context "成る" do
        let(:player) { Player.new("先手", field, :lower) }

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

        it "成っている状態から成らない状態に戻ろうとした" do
          player.initial_put_on("５五龍")
          player.execute("５六飛")
          pending "チェック↑"
        end

        context "成れないシリーズ" do
          it "自分の陣地に入るタイミングでは成れない" do
            player.initial_put_on("５五飛")
            proc { player.execute("５九飛成") }.should raise_error(NotPromotable)
          end

          it "自分の陣地から出るタイミングでも成れない" do
            player.initial_put_on("５九飛")
            proc { player.execute("５五飛成") }.should raise_error(NotPromotable)
          end

          it "天王山から一歩動いても成れない" do
            player.initial_put_on("５五飛")
            proc { player.execute("５六飛成") }.should raise_error(NotPromotable)
          end

          it "すでに成っているから成れない" do
            player.initial_put_on("５五龍")
            proc { player.execute("５一飛成") }.should raise_error(AlredyPromoted)
          end
        end
      end

      context "不成" do
        let(:player) { Player.new("先手", field, :lower) }

        it "成らない" do
          pending
        end

        it "ぜったいに成らないといけないのでエラー" do
          pending "５一桂不成のケース"
        end
      end

      context "取る" do
        it "相手の駒を取る" do
          player0 = Player.new("先手", field, :lower)
          player1 = Player.new("後手", field, :upper)
          player0.initial_put_on("５六歩")
          player1.initial_put_on("５五飛")
          soldier = field["５五"]
          player0.execute("５五歩")
          player0.pieces == [soldier.piece]
        end

        # MEMO: 相手がいないと絶対に「同角」は失敗するので相手がいないというエラーにした方がいいかもしれない
        it "一人で同を使う(同角で２五がわかった上で移動しようとしたけど自分の飛車がいるために移動できなかった)" do
          player = Player.new("先手", field, :lower)
          player.initial_put_on("２五飛")
          player.initial_put_on("８八角")
          player.execute("５五飛")
          proc { player.execute("同角") }.should raise_error(MovableSoldierNotFound, /5五に移動できる角がありません/)
        end

        it "同歩で取る" do
          frame = Frame.new
          frame.players << Player.new("先手", frame.field, :lower)
          frame.players << Player.new("後手", frame.field, :upper)
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
        let(:player) { Player.new("先手", field, :lower) }

        it "打てる" do
          player.execute("５五歩打")
          field["５五"].name.should == "▲5五歩"
        end

        it "成った状態では打てない" do
          proc { player.execute("５五馬打") }.should raise_error(PromotedPiecePutOnError)
        end

        it "「打」は曖昧なときだけ付くらしい(打がない場合、動けるのを推測で無いのを確認し、打つ)" do
          pending
          # 1. 動ける駒を探す→0件
          # 2. 持駒にその駒がある
          # 3. それを打つ
        end

        it "駒があるところには打てない" do
          pending
        end

        it "場外には打てない" do
          pending
        end

        it "１一歩打はエラー" do
          pending
        end
      end

      it "全体確認" do
        players = []
        players << Player.new("先手", field, :lower)
        players << Player.new("後手", field, :upper)
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
