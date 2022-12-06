require "spec_helper"

module Bioshogi
  module Explain
    describe AttackInfo do
      it "新米長玉" do
        info = Parser.parse("▲７六歩 △６二玉")
        assert { info.to_kif.include?("後手の戦型：新米長玉") }
        assert { info.xcontainer.player_at(:white).attack_infos.collect(&:name) == ["新米長玉"] }
      end

      it "嬉野流" do
        info = Parser.parse("▲６八銀")
        assert { info.to_kif.include?("嬉野流") }
      end

      it "tactic_info" do
        assert { AttackInfo.first.tactic_info.key == :attack }
      end

      it "UFO銀" do
        assert { AttackInfo["UFO銀"].name == "UFO銀" }
      end

      it "sample_kif_file" do
        assert { AttackInfo["UFO銀"].sample_kif_file.exist? }
      end

      it "sample_kif_info" do
        assert { AttackInfo["UFO銀"].sample_kif_info }
      end

      it "hit_turn" do
        assert { AttackInfo["UFO銀"].hit_turn == 23 }
      end

      it "distribution_ratio" do
        assert { AttackInfo["UFO銀"].distribution_ratio }
      end
    end
  end
end
