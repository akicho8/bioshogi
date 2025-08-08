require "spec_helper"

RSpec.describe Bioshogi::Board do
  it ".create_by_preset" do
    assert { Bioshogi::Board.create_by_preset("角落ち").preset_info.key == :"角落ち" }
  end

  describe "逆算" do
    it "トンボはマイナーなので major_only を有効にすると逆算できない" do
      board = Bioshogi::Board.new
      board.placement_from_preset("トンボ")
      assert { board.preset_info(major_only: true) == nil }
      assert { board.preset_info == Bioshogi::PresetInfo.fetch("トンボ") }
    end

    it "二枚落ちはメジャーなので逆算できる" do
      board = Bioshogi::Board.new
      board.placement_from_preset("二枚落ち")
      assert { board.preset_info == Bioshogi::PresetInfo.fetch("二枚落ち") }
    end
  end

  # Bioshogi::FIXME: container経由でテストを書いてはいけない
  it "配置" do
    container = Bioshogi::Container::Basic.new

    container.board.all_clear
    container.placement_from_preset("十九枚落ち")
    assert { container.board.preset_info(major_only: false)&.key == :"十九枚落ち" }

    container.board.all_clear
    container.board.placement_from_preset("十九枚落ち")
    assert { container.board.preset_info(major_only: false)&.key == :"十九枚落ち" }

    container.board.all_clear
    container.board.placement_from_preset("二十枚落ち")
    container.board.placement_from_human("△５一玉")
    assert { container.board.preset_info(major_only: false)&.key == :"十九枚落ち" }

    container.board.all_clear
    container.board.placement_from_shape <<~EOT
    +---------------------------+
    | ・ ・ ・ ・v玉 ・ ・ ・ ・|一
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|二
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|三
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
    | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
    | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
    | 香 桂 銀 金 玉 金 銀 桂 香|九
    +---------------------------+
      EOT
    assert { container.board.preset_info(major_only: false)&.key == :"十九枚落ち" }
  end

  it "サンプル" do
    board = Bioshogi::Board.new
    assert { board["５五"] == nil }
  end

  it "指定の座標だけを消す微妙なテスト" do
    Bioshogi::Dimension.change([1, 3]) do
      container = Bioshogi::Container::Basic.new
      container.player_at(:black).soldier_create("１三香")
      container.board.safe_delete_on(Bioshogi::Place["１三"])
      assert { container.board["１三"] == nil }
    end
  end

  it "駒柱に駒を置こうとしている" do
    board = Bioshogi::Board.create_by_preset("平手")
    board.place_on(Bioshogi::Soldier.from_str("▲24玉"))
    board.place_on(Bioshogi::Soldier.from_str("▲25玉"))
    board.place_on(Bioshogi::Soldier.from_str("▲26玉"))
    expect { board.place_on(Bioshogi::Soldier.from_str("▲25玉")) }.to raise_error(Bioshogi::MustNotHappen, /2の列に10個目の駒を配置しようとしています/)
  end
end
