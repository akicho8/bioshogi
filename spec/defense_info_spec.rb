require_relative "spec_helper"

module Bushido
  describe DefenseInfo do
    it "ある" do
      assert DefenseInfo["アヒル囲い"]
    end

    it "同じ" do
      DefenseInfo["アヒル囲い"].should == DefenseInfo["金開き"]
    end

    it "tactic_info" do
      DefenseInfo.first.tactic_info.key.should == :defense
    end

    describe "木構造" do
      it "先祖" do
        DefenseInfo["ダイヤモンド美濃"].ancestors.collect(&:name).should == ["美濃囲い", "片美濃囲い"]
      end

      it "親" do
        DefenseInfo["美濃囲い"].parent.name.should == "片美濃囲い"
      end

      it "子供" do
        DefenseInfo["片美濃囲い"].children.collect(&:name).should == ["美濃囲い", "銀美濃"]
      end

      it "子孫" do
        DefenseInfo["片美濃囲い"].descendants.collect(&:name).should == ["美濃囲い", "高美濃囲い", "ダイヤモンド美濃", "銀美濃"]
      end
    end

    describe "囲い" do
      it "囲いチェック", :if => Bushido.config.skill_set_flag do
        info = Parser.file_parse("#{__dir__}/yagura.kif")
        info.mediator_run
        info.header_part_string.should == <<~EOT
開始日時：1981/05/15 09:00:00
棋戦：名将戦
場所：東京「将棋会館」
手合割：平手
先手：加藤一二三
後手：原田泰夫
戦型：矢倉
先手の囲い：総矢倉, 菱矢倉
後手の囲い：雁木囲い
先手の戦型：四手角
後手の戦型：四手角
         EOT
      end
    end
  end
end
