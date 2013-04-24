# -*- coding: utf-8 -*-

require "spec_helper"

# standard_kif_spec でしっかりテストしているのでここで本気でテストする必要なし
module Bushido
  describe KifLog do
    before do
      @mediator = Mediator.test
    end

    it "初手７六歩" do
      kif_log = KifLog.new(:point => Point["７六"], :piece => Piece["歩"], :origin_point => Point["７七"], :player => @mediator.black_player)
      kif_log.to_pair.should == ["7六歩(77)", "7六歩"]
    end
  end
end
