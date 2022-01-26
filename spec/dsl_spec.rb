require "spec_helper"

module Bioshogi
  describe NotationDsl do
    it "試行錯誤用" do
      builder = NotationDsl.define do
        title "(title)"
        comment "(comment)"
        board "平手"
        # pieces black: "歩"
        mov "▲７六歩"
        mov "△３四歩"
      end
      builder.dump

      # sequencer = Sequencer.new
      # sequencer.pattern = builder
      #
      # sequencer.step_evaluate
      # p sequencer.board
      # p sequencer.variables
      #
      # sequencer.step_evaluate
      # p sequencer.board
      # p sequencer.variables
    end

    it "試行錯誤用2" do
      notation_dsl = NotationDsl.define do
        # title "(title)"
        # comment "(comment)"
        board <<~EOT
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・v桂v香|一
| ・ ・ ・ ・ ・ ・v金 ・ ・|二
| ・ ・ ・ ・ ・v歩 ・v歩 ・|三
| ・ ・ ・ ・ ・ ・v歩 ・v歩|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ 歩 ・ 歩|六
| ・ ・ ・ ・ ・ 歩 ・ ・ ・|七
| ・ ・ ・ ・ ・ ・ ・ 飛 ・|八
| ・ ・ ・ ・ ・ ・ ・ 桂 香|九
+---------------------------+
          EOT
        pieces "▲" => "歩4"
        mov "▲１五歩"
        mov "△同歩"
        push {
          mov "▲１二歩"
          snapshot "香車ゲット"
        }
        mov "▲１二歩"
        mov "△同香"
        snapshot "桂馬と香車とゲット"
      end

      sequencer = Sequencer.new
      sequencer.pattern = notation_dsl

      loop do
        r = sequencer.step_evaluate
        if r.nil?
          break
        end
        # p sequencer.hand_logs.last.to_ki2
        # p sequencer
        # p sequencer.variables
      end
    end

    describe "各コマンド" do
      def dsl_block(&block)
        builder = NotationDsl.define(&block)
        @sequencer = Sequencer.new
        @sequencer.pattern = builder
        @sequencer.evaluate
        @sequencer.mediator_stack.mediator
      end

      it "title" do
        assert { dsl_block { title "(title)" }.variables[:title]   == "(title)" }
      end

      it "comment" do
        assert { dsl_block { comment "(comment)" }.variables[:comment] == "(comment)" }
      end

      describe "board" do
        it { dsl_block { board "平手" }.board }
        it { dsl_block { board <<-EOT }.board }
+---+
|v香|一
| 香|九
+---+
EOT
      end

      it "mov" do
        dsl_block { board "平手"; mov "▲７六歩" }
      end

      it "pieces" do
        assert { dsl_block { pieces "▲" => "歩1 桂2" }.player_at("▲").piece_box.to_s == "桂二 歩" }
      end

      describe "stack" do
        it "push にブロック指定" do
          assert { dsl_block { board "平手"; push { mov "▲７六歩" }    }.hand_logs.count == 0 }
        end
        it "明示的に pop で戻る" do
          assert { dsl_block { board "平手"; push;  mov "▲７六歩"; pop }.hand_logs.count == 0 }
        end
        it "pushのみ" do
          assert { dsl_block { board "平手"; push;  mov "▲７六歩"      }.hand_logs.count == 1 }
        end
        it "スタックが空のときにpopできない" do
          expect { dsl_block { pop } }.to raise_error(MementoStackEmpty)
        end
      end
    end
  end
end
