# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Location do
    it "参照できるシリーズ" do
      Location[:black].key.must_equal :black
      Location["▲"].key.must_equal :black
      Location["▼"].key.must_equal :black
      Location["b"].key.must_equal :black
      Location["先手"].key.must_equal :black
      Location[0].key.must_equal :black
      Location["1手目"].key.must_equal :black
    end

    it "板パース時に楽するため" do
      Location[" "].key.must_equal :black
      Location["^"].key.must_equal :black
      Location["v"].key.must_equal :white
    end

    it "「n手目」は特別に n - 1 を index として parse している" do
      Location["0手目"].name.must_equal "後手" # 反則として「0手目」があるため上下限チェックは入れず緩くしておく
      Location["1手目"].name.must_equal "先手"
      Location["2手目"].name.must_equal "後手"
      Location["3手目"].name.must_equal "先手"
    end

    it "間違った引数シリーズ" do
      proc { Location[nil]     }.must_raise SyntaxError
      proc { Location[""]      }.must_raise SyntaxError
      proc { Location["foo"]   }.must_raise SyntaxError
      proc { Location["1手"]   }.must_raise SyntaxError
      proc { Location[-1]      }.must_raise SyntaxError
      proc { Location[2]       }.must_raise SyntaxError
    end

    it "Enumerable対応" do
      Location.each.present?.must_equal true
    end
  end
end
