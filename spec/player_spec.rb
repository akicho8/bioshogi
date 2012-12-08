# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Player do
    let(:field)  { Field.new }

    describe "#side_soldiers_put_on" do
      subject { Player.new("先手", field, :lower) }
      it "歩を相手の陣地に配置" do
        subject.side_soldier_put_on("5三歩")
        subject.soldiers.collect(&:to_text).should == ["▲5三歩"]
      end
      it "成っている歩を相手の陣地に配置" do
        subject.side_soldier_put_on("5三成歩")
        subject.soldiers.collect(&:to_text).should == ["▲5三成歩"]
      end
      it "成っている金を相手の陣地に配置" do
        proc { subject.side_soldier_put_on("5三成金") }.should raise_error(NotPromotable)
      end
      it "すでに駒があるところに駒を配置できない" do
        subject.side_soldier_put_on("5三歩")
        proc { subject.side_soldier_put_on("5三歩") }.should raise_error(PieceAlredyExist)
      end
      it "飛車は二枚持ってないので二枚配置できない" do
        subject.side_soldier_put_on("5二飛")
        proc { subject.side_soldier_put_on("5二飛") }.should raise_error(PieceNotFound)
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
          player.side_soldier_put_on("７七歩")
          soldier = field["７七"]
          player.execute("７六歩")
          field["７六"].should == soldier
          field["７七"].should == nil
        end

        it "後手の「３四歩」は３三の歩が上に上がる(画面上で下がることに注意)" do
          player = Player.new("後手", field, :upper)
          player.side_soldier_put_on("３三歩")
          soldier = field["３三"]
          player.execute("３四歩")
          field["３四"].should == soldier
          field["３三"].should == nil
        end
      end

      context "成る" do
        let(:player) { Player.new("先手", field, :lower) }

        it "相手陣地に入るときに成る" do
          player.side_soldier_put_on("２四歩")
          player.execute("２三歩成")
          field["２三"].promoted.should == true
        end

        it "相手陣地から出るときに成る" do
          player.side_soldier_put_on("５一飛")
          player.execute("５四飛成")
          field["５四"].promoted.should == true
        end

        context "成れないシリーズ" do
          it "自分の陣地に入るタイミングでは成れない" do
            player.side_soldier_put_on("５五飛")
            proc { player.execute("５九飛成") }.should raise_error(NotPromotable)
          end

          it "自分の陣地から出るタイミングでも成れない" do
            player.side_soldier_put_on("５九飛")
            proc { player.execute("５五飛成") }.should raise_error(NotPromotable)
          end

          it "天王山から一歩動いても成れない" do
            player.side_soldier_put_on("５五飛")
            proc { player.execute("５六飛成") }.should raise_error(NotPromotable)
          end

          it "すでに成っている" do
            player.side_soldier_put_on("５五成飛")
            proc { player.execute("５一飛成") }.should raise_error(AlredyPromoted)
          end
        end
      end

      context "成駒を動かす" do
        it do
          pending
        end
      end

      context "どこから動かすか指定されたフォーマットに対応する" do
        it do
          pending
        end
      end

      context "推測結果が複数パターンがあったときにエラーにする" do
        it do
          pending
        end
      end

      context "取る" do
        it "相手の駒を取る" do
          player0 = Player.new("先手", field, :lower)
          player1 = Player.new("後手", field, :upper)
          player0.side_soldier_put_on("５六歩")
          player1.side_soldier_put_on("５五飛")
          soldier = field["５五"]
          player0.execute("５五歩")
          player0.pieces == [soldier.piece]
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
|      | 飛↓ |      |      |      |      |      | 成角 |      | 二 |
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
