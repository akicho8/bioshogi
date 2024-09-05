require "spec_helper"

module Bioshogi
  RSpec.describe Board do
    describe "逆算" do
      it "トンボはマイナーなので逆算できない" do
        board = Board.new
        board.placement_from_preset("トンボ")
        assert { board.preset_info                         == nil }
        assert { board.preset_info(inclusion_minor: false) == nil }
        assert { board.preset_info(inclusion_minor: true)  == PresetInfo.fetch("トンボ") }
      end

      it "二枚落ちはメジャーなので逆算できる" do
        board = Board.new
        board.placement_from_preset("二枚落ち")
        assert { board.preset_info                         == PresetInfo.fetch("二枚落ち") }
        assert { board.preset_info(inclusion_minor: false) == PresetInfo.fetch("二枚落ち") }
        assert { board.preset_info(inclusion_minor: true)  == PresetInfo.fetch("二枚落ち") }
      end
    end

    # FIXME: container経由でテストを書いてはいけない
    it "配置" do
      container = Container::Basic.new

      container.board.all_clear
      container.placement_from_preset("裸玉")
      assert { container.board.preset_info(inclusion_minor: true)&.key == :"十九枚落ち" }

      container.board.all_clear
      container.board.placement_from_preset("裸玉")
      assert { container.board.preset_info(inclusion_minor: true)&.key == :"十九枚落ち" }

      container.board.all_clear
      container.board.placement_from_preset("二十枚落ち")
      container.board.placement_from_human("△５一玉")
      assert { container.board.preset_info(inclusion_minor: true)&.key == :"十九枚落ち" }

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
      assert { container.board.preset_info(inclusion_minor: true)&.key == :"十九枚落ち" }
    end

    it "サンプル" do
      board = Board.new
      assert { board["５五"] == nil }
    end

    it "指定の座標だけを消す微妙なテスト" do
      Dimension.wh_change([1, 3]) do
        container = Container::Basic.new
        container.player_at(:black).soldier_create("１三香")
        container.board.safe_delete_on(Place["１三"])
        assert { container.board["１三"] == nil }
      end
    end

    it "駒柱に駒を置こうとしている" do
      board = Board.create_by_preset("平手")
      board.place_on(Soldier.from_str("▲24玉"))
      board.place_on(Soldier.from_str("▲25玉"))
      board.place_on(Soldier.from_str("▲26玉"))
      expect { board.place_on(Soldier.from_str("▲25玉")) }.to raise_error(MustNotHappen, /2の列に10個目の駒を配置しようとしています/)
    end
  end
end
# >> Coverage report generated for RSpec to /Users/ikeda/src/bioshogi/coverage. 7 / 15 LOC (46.67%) covered.
# >> ....
# >>
# >> Top 4 slowest examples (0.07819 seconds, 93.9% of total time):
# >>   Bioshogi::Board 逆算
# >>     0.07257 seconds -:5
# >>   Bioshogi::Board 配置
# >>     0.00495 seconds -:13
# >>   Bioshogi::Board 指定の座標だけを消す微妙なテスト
# >>     0.00046 seconds -:51
# >>   Bioshogi::Board サンプル
# >>     0.00022 seconds -:46
# >>
# >> Finished in 0.08327 seconds (files took 1.63 seconds to load)
# >> 4 examples, 0 failures
# >>
