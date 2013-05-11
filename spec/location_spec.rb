# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Location do
    it "参照できるシリーズ" do
      Location[:black].key.should  == :black
      Location["▲"].key.should    == :black
      Location["▼"].key.should    == :black
      Location["b"].key.should     == :black
      Location["先手"].key.should  == :black
      Location[0].key.should       == :black
      Location["1手目"].key.should == :black
    end

    it "盤面を読み取るときに楽するため" do
      Location[" "].key.should     == :black
      Location["^"].key.should     == :black
      Location["v"].key.should     == :white
    end

    it "KIF形式でインデックスから手番に変換するとき楽するため" do
      # 内部的には「n手目」は特別に n - 1 を index として parse している
      Location["0手目"].name.should == "後手" # 反則として「0手目」があるため上下限チェックは入れず緩くしておく
      Location["1手目"].name.should == "先手"
      Location["2手目"].name.should == "後手"
      Location["3手目"].name.should == "先手"
    end

    it "間違った引数シリーズ" do
      expect { Location[nil]     }.to raise_error(SyntaxError)
      expect { Location[""]      }.to raise_error(SyntaxError)
      expect { Location["foo"]   }.to raise_error(SyntaxError)
      expect { Location["1手"]   }.to raise_error(SyntaxError)
      expect { Location[-1]      }.to raise_error(SyntaxError)
      expect { Location[2]       }.to raise_error(SyntaxError)
    end

    it "Enumerable対応" do
      Location.each.present?.should == true
    end

    it "とにかく短かく書きたいとき用のエイリアス" do
      L.b.should == Location[:black]
      L.w.should == Location[:white]
    end

    it "次の手番を返す" do
      Location[:white].reverse.should == Location[:black]
      Location[:white].next_location.should == Location[:black]
    end

    it "属性っぽい値を全部返す" do
      L.b.match_target_values.should be_an_instance_of Array
    end

    it "先手後手を表す文字一覧の正規表現" do
      L.triangles.should == "▲▼▽△"
    end
  end
end
