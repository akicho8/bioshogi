require_relative "spec_helper"

module Warabi
  describe Mediator do
    it "交互に打ちながら戦況表示" do
      mediator = Mediator.start
      mediator.piece_plot
      mediator.execute(["７六歩", "３四歩"])
      mediator.turn_info.counter.should == 2
      mediator.turn_max.should == 2
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
EOT
    end

    if false
      it "CPU同士で対局" do
        mediator = Mediator.start
        mediator.piece_plot
        loop do
          think_result = mediator.current_player.brain.think_by_minmax(depth: 0, random: true)
          hand = Warabi::Utils.mov_split_one(think_result[:hand])[:input]
          # hand = mediator.current_player.brain.all_hands.sample
          p hand
          mediator.execute(hand)
          p mediator
          last_piece_taken_from_opponent = mediator.reverse_player.last_piece_taken_from_opponent
          break
          if last_piece_taken_from_opponent && last_piece_taken_from_opponent.key == :king
            break
          end
        end
        p mediator.kif_hand_logs.join(" ")
      end
    end

    it "状態の復元" do
      mediator = Mediator.test(init: "▲１五玉 ▲１四歩 △１一玉 △１二歩", exec: ["１三歩成", "１三歩"])
      dup = mediator.deep_dup
      mediator.turn_info.counter.should == dup.turn_info.counter
      mediator.kif_hand_logs.should     == dup.kif_hand_logs
      mediator.ki2_hand_logs.should     == dup.ki2_hand_logs
      mediator.to_s.should              == dup.to_s

      mediator.board.to_s_soldiers == dup.board.to_s_soldiers

      mediator.reverse_player.location                       == dup.reverse_player.location
      mediator.reverse_player.piece_box.to_s                 == dup.reverse_player.piece_box.to_s
      mediator.reverse_player.to_s_soldiers                  == dup.reverse_player.to_s_soldiers
      mediator.reverse_player.last_piece_taken_from_opponent == dup.reverse_player.last_piece_taken_from_opponent
    end

    it "相手が前回打った位置を復元するので同歩ができる" do
      mediator = Mediator.test(init: "▲１五歩 △１三歩", exec: "１四歩")
      mediator = Marshal.load(Marshal.dump(mediator))
      mediator.execute("同歩")
      mediator.reverse_player.runner.hand_log.to_kif_ki2.should == ["１四歩(13)", "同歩"]
    end

    it "同歩からの同飛になること" do
      mediator = SimulatorFrame.new({execute: "▲２六歩 △２四歩 ▲２五歩 △同歩 ▲同飛", board: "平手"})
      mediator.build_frames
      mediator.ki2_hand_logs.should == ["▲２六歩", "△２四歩", "▲２五歩", "△同歩", "▲同飛"]
    end

    it "Sequencer" do
      data = KifuDsl.define{}
      sequencer = Sequencer.new
      sequencer.pattern = data
      sequencer.evaluate
      sequencer.frames
    end

    it "フレームのサンドボックス実行(重要)" do
      mediator = Mediator.test(init: "▲１二歩")
      mediator.player_at(:black).to_s_soldiers.should == "１二歩"
      mediator.player_at(:black).board.to_s_soldiers.should == "１二歩"
      mediator.sandbox_for { mediator.player_at(:black).execute("２二歩打") }
      mediator.player_at(:black).to_s_soldiers.should == "１二歩"
      mediator.player_at(:black).board.to_s_soldiers.should == "１二歩"
    end

    it "「打」にすると Marshal.dump できない件→修正" do
      mediator = Mediator.test(exec: "１二歩打")
      mediator.deep_dup
    end

    if false
      it "XtraPattern", p: true do
        XtraPattern.reload_all
        XtraPattern.each do |pattern|
          if pattern[:dsl]
            mediator = Sequencer.new
            mediator.pattern = pattern[:dsl]
            mediator.evaluate
            # p mediator.frames
          else
            mediator = SimulatorFrame.new(pattern)
            mediator.build_frames
            # mediator.build_frames{|e|p e}
          end
        end
      end
    end
  end
end
