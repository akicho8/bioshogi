# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe do
    it "盤面表示" do
      pending

      field = Field.new
      players = []
      players << Player.create2(:black, field)
      players << Player.create2(:white, field)
      players.each(&:setup)
      field.to_kif_table.should == <<-FIELD.strip_heredoc
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・v桂v銀v金v玉v金v銀v桂v香|一
| ・v飛 ・ ・ ・ ・ ・v角 ・|二
|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 銀 桂 香|九
+---------------------------+
FIELD
    end
    Player
  end
end
