require_relative "spec_helper"

# standard_kif_spec でいろんなパターンをテストしているのでここでテストするのは基本のメソッドだけでOK
module Bushido
  describe HandLog do
    before do
      @mediator = Mediator.test

      # 初手７六歩
      @hand_log = HandLog.new(point_to: Point["７六"], piece: Piece["歩"], point_from: Point["７七"], player: @mediator.black_player)
    end

    it "CPU向けの表記を返す" do
      @hand_log.to_s_kif.should == "７六歩(77)"
    end

    it "人間向けの表記を返す" do
      @hand_log.to_s_ki2.should == "７六歩"
    end

    it "両方返す" do
      @hand_log.to_kif_ki2.should == ["７六歩(77)", "７六歩"]
    end
  end
end
