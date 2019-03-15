require_relative "spec_helper"

module Warabi
  describe DefenseInfo do
    it "ある" do
      assert { DefenseInfo["アヒル囲い"] }
    end

    it "同じ" do
      assert DefenseInfo["アヒル囲い"] == DefenseInfo["金開き"]
    end

    it "tactic_info" do
      assert { DefenseInfo.first.tactic_info.key == :defense }
    end

    describe "木構造" do
      it "先祖" do
        assert { DefenseInfo["ダイヤモンド美濃"].ancestors.collect(&:name) == ["美濃囲い", "片美濃囲い"] }
      end

      it "親" do
        assert { DefenseInfo["美濃囲い"].parent.name == "片美濃囲い" }
      end

      it "子供" do
        assert { DefenseInfo["片美濃囲い"].children.collect(&:name) == ["美濃囲い", "銀美濃", "ちょんまげ美濃"] }
      end

      it "子孫" do
        assert { DefenseInfo["片美濃囲い"].descendants.collect(&:name) == ["美濃囲い", "高美濃囲い", "ダイヤモンド美濃", "銀美濃", "ちょんまげ美濃", "坊主美濃"] }
      end
    end

    describe "囲い" do
      it "囲いチェック", :if => Warabi.config.skill_monitor_enable do
        info = Parser.file_parse("#{__dir__}/yagura.kif")
        info.mediator_run
        # puts info.header_part_string
        assert { info.header_part_string == <<~EOT }
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
先手の手筋：垂れ歩, 継ぎ桂, ふんどしの桂
             EOT
      end
    end
  end
end
