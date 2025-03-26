require "spec_helper"

RSpec.describe Bioshogi::Analysis::AttackInfo do
  it ".human_name" do
    assert { Bioshogi::Analysis::AttackInfo.human_name == "戦法" }
  end

  it "新米長玉" do
    info = Bioshogi::Parser.parse("▲７六歩 △６二玉")
    assert { info.to_kif.include?("後手の戦法：新米長玉") }
    assert { info.formatter.container.player_at(:white).attack_infos.collect(&:name) == ["新米長玉"] }
  end

  it "嬉野流" do
    info = Bioshogi::Parser.parse("▲６八銀")
    assert { info.to_kif.include?("嬉野流") }
  end

  it "tactic_info" do
    assert { Bioshogi::Analysis::AttackInfo.first.tactic_info.key == :attack }
  end

  it "group_info" do
    assert { Bioshogi::Analysis::AttackInfo["清野流岐阜戦法"].group_info.key == :"右玉" }
  end

  it "UFO銀" do
    assert { Bioshogi::Analysis::AttackInfo["UFO銀"].name == "UFO銀" }
  end

  it "main_reference_file" do
    assert { Bioshogi::Analysis::AttackInfo["UFO銀"].main_reference_file.exist? }
  end

  it "main_reference_info" do
    assert { Bioshogi::Analysis::AttackInfo["UFO銀"].main_reference_info }
  end

  it "hit_turn" do
    assert { Bioshogi::Analysis::AttackInfo["UFO銀"].hit_turn == 23 }
  end

  it "frequency" do
    assert { Bioshogi::Analysis::AttackInfo["UFO銀"].frequency }
  end

  it "style_info" do
    assert { Bioshogi::Analysis::AttackInfo["UFO銀"].style_info }
  end
end
