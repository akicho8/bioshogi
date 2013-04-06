# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Mediator do
    describe "囲い" do
      it "囲いチェック" do
        value = <<-BOARD
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金v銀v桂v香|一
| ・v飛 ・ ・ ・ ・ ・v角 ・|二
|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ 歩 歩 歩 ・ ・ ・ ・|六
| ・ ・ ・ ・ ・ ・ ・ ・ ・|七
| ・ 角 金 銀 金 ・ ・ ・ ・|八
| ・ ・ ・ 玉 ・ ・ ・ ・ ・|九
+---------------------------+
BOARD
        # リアルタイムに調べる
        mediator = Mediator.new
        mediator.board_reset(value)
        # puts mediator.board
        mediator.player_at(:black).defense_form_keys.include?("カニ囲い").should == true
        mediator.player_at(:black).complete_defense_names.should == []

        # 打った直後に記録する
        mediator.player_at(:black).complete_defense_names.should == []
        mediator.player_at(:black).defense_name_append?.should == false
        mediator.execute("９九角")
        mediator.player_at(:black).complete_defense_names.include?("カニ囲い").should == true
        mediator.player_at(:black).defense_name_append?.should == true
      end

      it "空白の部分が重要な「坊主美濃」のチェックが可能" do
        pending

#         value = <<-BOARD
#   ９ ８ ７ ６ ５ ４ ３ ２ １
# +---------------------------+
# |v香v桂v銀v金v玉v金v銀v桂v香|一
# | ・v飛 ・ ・ ・ ・ ・v角 ・|二
# |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# | ・ ・ 歩 歩 歩 ・ ・ ・ ・|六
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# | ・ 角 金 銀 金 ・ ・ ・ ・|八
# | ・ ・ ・ 玉 ・ ・ ・ ・ ・|九
# +---------------------------+
# BOARD
#         # リアルタイムに調べる
#         mediator = Mediator.new
#         mediator.board_reset(value)
#         # puts mediator.board
#         mediator.player_at(:black).defense_form_keys.include?("カニ囲い").should == true
#         mediator.player_at(:black).complete_defense_names.should == []
# 
#         # 打った直後に記録する
#         mediator.player_at(:black).complete_defense_names.should == []
#         mediator.player_at(:black).defense_name_append?.should == false
#         mediator.execute("９九角")
#         mediator.player_at(:black).complete_defense_names.include?("カニ囲い").should == true
#         mediator.player_at(:black).defense_name_append?.should == true
      end

      #       it "test" do
      #         mediator = Mediator.new
      #         mediator.board_reset <<-BOARD
      #   ９ ８ ７ ６ ５ ４ ３ ２ １
      # +---------------------------+
      # |v香v桂v銀v金v玉v金v銀v桂v香|一
      # | ・v飛 ・ ・ ・ ・ ・v角 ・|二
      # |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
      # | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
      # | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
      # | ・ ・ 歩 歩 歩 ・ ・ ・ ・|六
      # | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
      # | ・ 角 金 銀 金 ・ ・ ・ ・|八
      # | ・ ・ ・ 玉 ・ ・ ・ ・ ・|九
      # +---------------------------+
      # BOARD
      #         # p mediator.board.to_s
      #         mediator.player_at(:black).defense_form_keys.should == ["カニ囲い"]
      #         mediator.player_at(:black).complete_defense_names.should == []
      #
      #         # 打った直後に記録する
      #         mediator.player_at(:black).complete_defense_names.should == []
      #         mediator.player_at(:black).defense_name_append?.should == false
      #         mediator.execute("９九角")
      #         mediator.player_at(:black).complete_defense_names.should == ["カニ囲い"]
      #         mediator.player_at(:black).defense_name_append?.should == true
      #       end
      #     end
    end
  end
end
