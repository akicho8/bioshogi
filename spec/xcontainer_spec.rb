require "spec_helper"

module Bioshogi
  describe Xcontainer do
    it "normalized_names_with_alias" do
      xcontainer = Xcontainer.new
      xcontainer.player_at(:black).skill_set.attack_infos << AttackInfo["中田功XP"]
      xcontainer.player_at(:white).skill_set.defense_infos << DefenseInfo["美濃囲い"]
      assert { xcontainer.normalized_names_with_alias == ["中田功XP", "コーヤン流", "美濃囲い"] }
    end

    it "not_enough_piece_box" do
      xcontainer = Xcontainer.new
      xcontainer.placement_from_bod <<~EOT
      後手の持駒：香
      ９ ８ ７ ６ ５ ４ ３ ２ １
      +---------------------------+
        | ・v桂v銀v金v玉v金v銀v桂v香|一
      | ・v飛 ・ ・ ・ ・ ・v角 ・|二
      |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
      | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
      | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
      | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
      | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
      | ・ 角 ・ ・ ・ ・ ・ ・ ・|八
      | 香 桂 銀 金 ・ 金 銀 桂 ・|九
      +---------------------------+
        先手の持駒：飛
      EOT

      assert { xcontainer.to_piece_box == {:rook=>2, :lance=>3, :knight=>4, :silver=>4, :gold=>4, :king=>1, :bishop=>2, :pawn=>18} }
      assert { xcontainer.not_enough_piece_box.to_s == "玉 香" }

      piece_box = xcontainer.not_enough_piece_box
      piece_box.delete(:king)
      assert { piece_box.to_s == "香" }
    end

    describe "placement_from_preset" do
      it "盤を反映する" do
        xcontainer = Xcontainer.new
        xcontainer.placement_from_preset("5五将棋")
        assert { xcontainer.to_short_sfen == "position sfen 4rbsgk/8p/9/4P4/4KGSBR/9/9/9/9 b - 1" }
        assert { xcontainer.turn_info.handicap == false }
      end

      it "手番を反映する" do
        xcontainer = Xcontainer.new
        xcontainer.placement_from_preset("香落ち")
        assert { xcontainer.turn_info.handicap }
      end

      it "持駒を反映する" do
        xcontainer = Xcontainer.new
        xcontainer.placement_from_preset("バリケード将棋")
        assert { xcontainer.player_at(:black).piece_box.to_s == "飛 角 香" }
        assert { xcontainer.player_at(:white).piece_box.to_s == "飛 角 香" }
      end
    end

    it "交互に打ちながら戦況表示" do
      xcontainer = Xcontainer.new
      xcontainer.placement_from_preset("平手")
      xcontainer.execute(["７六歩", "３四歩"])
      assert { xcontainer.turn_info.turn_offset == 2 }
      assert { xcontainer.turn_info.display_turn == 2 }
      xcontainer.judgment_message == "まで2手で後手の勝ち"
      assert { xcontainer.to_s == <<-EOT }
後手の持駒：なし
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金v銀v桂v香|一
| ・v飛 ・ ・ ・ ・ ・v角 ・|二
|v歩v歩v歩v歩v歩v歩 ・v歩v歩|三
| ・ ・ ・ ・ ・ ・v歩 ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ 歩 ・ ・ ・ ・ ・ ・|六
| 歩 歩 ・ 歩 歩 歩 歩 歩 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 銀 桂 香|九
+---------------------------+
先手の持駒：なし
手数＝2 △３四歩(33) まで
先手番
EOT
    end

    it "状態の復元" do
      xcontainer = Xcontainer.facade(init: "▲１五玉 ▲１四歩 △１一玉 △１二歩", execute: ["１三歩成", "１三歩"])
      m2 = xcontainer.deep_dup
      assert { xcontainer.turn_info.turn_offset == m2.turn_info.turn_offset }
      assert { xcontainer.to_kif_a     == m2.to_kif_a }
      assert { xcontainer.to_ki2_a     == m2.to_ki2_a }
      assert { xcontainer.to_s              == m2.to_s }

      xcontainer.board.to_s_soldiers == m2.board.to_s_soldiers

      xcontainer.opponent_player.location                == m2.opponent_player.location
      xcontainer.opponent_player.piece_box.to_s          == m2.opponent_player.piece_box.to_s
      xcontainer.opponent_player.to_s_soldiers           == m2.opponent_player.to_s_soldiers
      xcontainer.opponent_player.executor.captured_soldier == m2.opponent_player.executor.captured_soldier
    end

    it "相手が前回打った位置を復元するので同歩ができる" do
      xcontainer = Xcontainer.facade(init: "▲１五歩 △１三歩", execute: "１四歩")
      xcontainer = Marshal.load(Marshal.dump(xcontainer))
      xcontainer.execute("同歩")
      assert { xcontainer.opponent_player.executor.hand_log.to_kif_ki2 == ["１四歩(13)", "同歩"] }
    end

    it "同歩からの同飛になること" do
      object = Simulator.run({execute: "▲２六歩 △２四歩 ▲２五歩 △同歩 ▲同飛", board: "平手"})
      assert { object.xcontainer.to_ki2_a == ["▲２六歩", "△２四歩", "▲２五歩", "△同歩", "▲同飛"] }
    end

    it "Sequencer" do
      data = NotationDsl.define{}
      sequencer = Sequencer.new
      sequencer.pattern = data
      sequencer.evaluate
      sequencer.snapshots
    end

    it "フレームのサンドボックス実行(重要)" do
      xcontainer = Xcontainer.facade(init: "▲１二歩", pieces_set: "▼歩")
      assert { xcontainer.player_at(:black).to_s_soldiers == "１二歩" }
      assert { xcontainer.player_at(:black).board.to_s_soldiers == "１二歩" }
      xcontainer.context_new { |e| e.player_at(:black).execute("２二歩打") }
      assert { xcontainer.player_at(:black).to_s_soldiers == "１二歩" }
      assert { xcontainer.player_at(:black).board.to_s_soldiers == "１二歩" }
    end

    it "「打」にすると Marshal.dump できない件→修正" do
      xcontainer = Xcontainer.facade(execute: "１二歩打", pieces_set: "▼歩")
      xcontainer.deep_dup
    end

    if false
      it "XtraPattern", p: true do
        XtraPattern.reload_all
        XtraPattern.each do |pattern|
          if pattern[:notation_dsl]
            xcontainer = Sequencer.new
            xcontainer.pattern = pattern[:notation_dsl]
            xcontainer.evaluate
            # p xcontainer.snapshots
          else
            xcontainer = Simulator.new(pattern)
            xcontainer.execute
            # xcontainer.execute{|e|p e}
          end
        end
      end
    end

    describe "手数を得る" do
      before do
        @info = Xcontainer.start
        @info.execute("76歩")
        @info.execute("34歩")
        @info.execute("22角成")
        @info.execute("同銀")
        @info.execute("55角")
        @info.execute("54歩")
        @info.execute("22角成")
      end

      it "駒が取られる直前の手数" do
        assert { @info.critical_turn == 2 }
      end

      it "「角と歩」以外の駒が取られる直前の手数" do
        assert { @info.outbreak_turn == 6 }
      end
    end
  end
end
# >> Coverage report generated for RSpec to /Users/ikeda/src/bioshogi/coverage. 7 / 15 LOC (46.67%) covered.
# >> ..............
# >> 
# >> Top 10 slowest examples (0.04938 seconds, 81.4% of total time):
# >>   Bioshogi::Xcontainer normalized_names_with_alias
# >>     0.00994 seconds -:5
# >>   Bioshogi::Xcontainer 同歩からの同飛になること
# >>     0.0076 seconds -:111
# >>   Bioshogi::Xcontainer 状態の復元
# >>     0.00736 seconds -:88
# >>   Bioshogi::Xcontainer 交互に打ちながら戦況表示
# >>     0.00611 seconds -:60
# >>   Bioshogi::Xcontainer 手数を得る 「角と歩」以外の駒が取られる直前の手数
# >>     0.00411 seconds -:172
# >>   Bioshogi::Xcontainer not_enough_piece_box
# >>     0.00383 seconds -:12
# >>   Bioshogi::Xcontainer 手数を得る 駒が取られる直前の手数
# >>     0.00382 seconds -:168
# >>   Bioshogi::Xcontainer placement_from_preset 手番を反映する
# >>     0.00244 seconds -:46
# >>   Bioshogi::Xcontainer placement_from_preset 持駒を反映する
# >>     0.00222 seconds -:52
# >>   Bioshogi::Xcontainer フレームのサンドボックス実行(重要)
# >>     0.00192 seconds -:124
# >> 
# >> Finished in 0.06067 seconds (files took 1.52 seconds to load)
# >> 14 examples, 0 failures
# >> 
