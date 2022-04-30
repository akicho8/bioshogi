require "spec_helper"

module Bioshogi
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
        assert { DefenseInfo["片美濃囲い"].children.collect(&:name) == ["美濃囲い", "片銀冠", "銀美濃", "木村美濃", "大山美濃", "ちょんまげ美濃"] }
      end

      it "子孫" do
        assert { DefenseInfo["片美濃囲い"].descendants.collect(&:name) == ["美濃囲い", "高美濃囲い", "振り飛車四枚美濃", "ダイヤモンド美濃", "片銀冠", "銀冠", "銀美濃", "木村美濃", "大山美濃", "ちょんまげ美濃", "坊主美濃"] }
      end
    end

    describe "囲い" do
      it "囲いチェック", :if => Bioshogi.config.skill_monitor_enable do
        info = Parser.file_parse("#{__dir__}/files/矢倉.kif")
        assert { info.to_kif.include?(<<~EOT) }
開始日時：1981/05/15 09:00:00
棋戦：名将戦
場所：東京「将棋会館」
手合割：平手
先手：加藤一二三
後手：原田泰夫
戦型：矢倉
先手の戦型：四手角
後手の戦型：四手角
先手の囲い：総矢倉, 菱矢倉, へこみ矢倉
先手の手筋：垂れ歩, 継ぎ桂, ふんどしの桂
先手の備考：居飛車
後手の備考：居飛車
  EOT
      end
    end
  end
end
