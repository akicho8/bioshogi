# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Utils do
    it "文字列の分解" do
      Utils.parse_str("４二竜").should == {:point => Point["４二"], :piece => Piece["竜"], :promoted => true}
    end

    it "初期配置" do
      Utils.initial_placements_for(:white).should be_present
    end

    it "初期配置" do
      Utils.ki2_input_seq_parse("▲５五歩△４四歩 push ▲３三歩 pop").should == [{:location => :black, :input => "５五歩"}, {:location => :white, :input => "４四歩"}, "push", {:location => :black, :input => "３三歩"}, "pop"]
    end
  end
end
