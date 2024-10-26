require "spec_helper"

module Bioshogi
  module Analysis
    describe DefenseInfo do
      xdescribe "keyとnameは異なる" do
        it "key" do
          assert { DefenseInfo["ビッグ4(振)"].key == :"ビッグ4(振)" }
        end
        it "name" do
          assert { DefenseInfo["ビッグ4(振)"].name == "ビッグ4" }
        end
      end

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
          assert { DefenseInfo["片美濃囲い"].children.collect(&:name) == ["美濃囲い", "片銀冠", "銀美濃", "木村美濃", "大山美濃", "美濃熊囲い"] }
        end

        it "子孫" do
          assert { DefenseInfo["片美濃囲い"].descendants.collect(&:name) == ["美濃囲い", "高美濃囲い", "振り飛車四枚美濃", "ダイヤモンド美濃", "片銀冠", "銀冠", "銀美濃", "木村美濃", "裾固め", "大山美濃", "美濃熊囲い"] }
        end
      end
    end
  end
end
