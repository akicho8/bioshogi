require_relative "spec_helper"

module Warabi
  describe Mediator do
    it "placement_from_preset は手番も反映する" do
      mediator = Mediator.new
      mediator.placement_from_preset("香落ち")
      mediator.to_long_sfen.should == "sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1"
    end

    it "交互に打ちながら戦況表示" do
      mediator = Mediator.new
      mediator.placement_from_preset("平手")
      mediator.execute(["７六歩", "３四歩"])
      mediator.turn_info.counter.should == 2
      mediator.turn_info.turn_max.should == 2
      mediator.judgment_message == "まで2手で後手の勝ち"
      mediator.to_s.should == <<-EOT
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
      mediator = Mediator.test1(init: "▲１五玉 ▲１四歩 △１一玉 △１二歩", execute: ["１三歩成", "１三歩"])
      m2 = mediator.deep_dup
      mediator.turn_info.counter.should == m2.turn_info.counter
      mediator.to_kif_a.should     == m2.to_kif_a
      mediator.to_ki2_a.should     == m2.to_ki2_a
      mediator.to_s.should              == m2.to_s

      mediator.board.to_s_soldiers == m2.board.to_s_soldiers

      mediator.opponent_player.location                == m2.opponent_player.location
      mediator.opponent_player.piece_box.to_s          == m2.opponent_player.piece_box.to_s
      mediator.opponent_player.to_s_soldiers           == m2.opponent_player.to_s_soldiers
      mediator.opponent_player.executor.captured_soldier == m2.opponent_player.executor.captured_soldier
    end

    it "相手が前回打った位置を復元するので同歩ができる" do
      mediator = Mediator.test1(init: "▲１五歩 △１三歩", execute: "１四歩")
      mediator = Marshal.load(Marshal.dump(mediator))
      mediator.execute("同歩")
      mediator.opponent_player.executor.hand_log.to_kif_ki2.should == ["１四歩(13)", "同歩"]
    end

    it "同歩からの同飛になること" do
      object = Simulator.run({execute: "▲２六歩 △２四歩 ▲２五歩 △同歩 ▲同飛", board: "平手"})
      object.mediator.to_ki2_a.should == ["▲２六歩", "△２四歩", "▲２五歩", "△同歩", "▲同飛"]
    end

    it "Sequencer" do
      data = NotationDsl.define{}
      sequencer = Sequencer.new
      sequencer.pattern = data
      sequencer.evaluate
      sequencer.snapshots
    end

    it "フレームのサンドボックス実行(重要)" do
      mediator = Mediator.test1(init: "▲１二歩", pieces_set: "▼歩")
      mediator.player_at(:black).to_s_soldiers.should == "１二歩"
      mediator.player_at(:black).board.to_s_soldiers.should == "１二歩"
      mediator.context_new { |e| e.player_at(:black).execute("２二歩打") }
      mediator.player_at(:black).to_s_soldiers.should == "１二歩"
      mediator.player_at(:black).board.to_s_soldiers.should == "１二歩"
    end

    it "「打」にすると Marshal.dump できない件→修正" do
      mediator = Mediator.test1(execute: "１二歩打", pieces_set: "▼歩")
      mediator.deep_dup
    end

    if false
      it "XtraPattern", p: true do
        XtraPattern.reload_all
        XtraPattern.each do |pattern|
          if pattern[:notation_dsl]
            mediator = Sequencer.new
            mediator.pattern = pattern[:notation_dsl]
            mediator.evaluate
            # p mediator.snapshots
          else
            mediator = Simulator.new(pattern)
            mediator.execute
            # mediator.execute{|e|p e}
          end
        end
      end
    end
  end
end
