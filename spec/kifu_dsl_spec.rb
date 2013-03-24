# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe KifuDsl do
    it "試行錯誤用" do
      builder = KifuDsl.define do
        title "(title)"
        comment "(comment)"
        board "平手"
        # pieces :black => "歩"
        mov "▲７六歩"
        mov "△３四歩"
      end
      builder.dump

      # sequencer = Sequencer.new
      # sequencer.pattern = builder
      #
      # sequencer.eval_step
      # p sequencer.board
      # p sequencer.variables
      #
      # sequencer.eval_step
      # p sequencer.board
      # p sequencer.variables
    end

    it "試行錯誤用2" do
      table = [
        {
          :title => "付き捨て+タタキ+合わせ",
          :dsl => KifuDsl.define do
            # title "(title)"
            # comment "(comment)"
            board <<-BOARD
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
BOARD
            pieces "先手" => "歩4"
            mov "▲１五歩"
            mov "△同歩"
            push {
              mov "▲１二歩"
              mov "△同香"
              mov "▲１三歩"
              mov "△同香"
              mov "▲１四歩"
              mov "△同香"
              mov "▲２四歩"
              mov "△同歩"
              mov "▲同飛"
              mov "△２三歩"
              mov "▲１四飛"
              disp "香車ゲット"
            }
            mov "▲１三歩"
            mov "△同桂"
            mov "▲１二歩"
            mov "△同香"
            mov "▲１四歩"
            mov "▲１五香"
            mov "▲１三歩成"
            mov "△１三香"
            mov "▲１三香成"
            disp "桂馬と香車とゲット"
          end
        }
      ]

      sequencer = Sequencer.new
      sequencer.pattern = table.first[:dsl]

      loop do
        r = sequencer.eval_step
        if r.nil?
          break
        end
        # p sequencer.kif_logs.last.to_s_human
        # p sequencer
        # p sequencer.variables
      end
    end

    describe "各コマンド" do
      def dsl_block(&block)
        builder = KifuDsl.define(&block)
        @sequencer = Sequencer.new
        @sequencer.pattern = builder
        @sequencer.evaluate
        @sequencer
      end

      it "title" do
        dsl_block{ title "(title)" }.variables[:title].should   == "(title)"
      end

      it "comment" do
        dsl_block{ comment "(comment)" }.variables[:comment].should == "(comment)"
      end

      it "board" do
        dsl_block{ board "平手" }.board
        dsl_block{ board }.board
      end

      it "mov" do
        dsl_block{ board; mov "▲７六歩" }
      end

      it "pieces" do
        dsl_block{ pieces "▲" => "歩1 桂2" }.player_at("▲").to_s_pieces.should == "歩 桂二"
      end

      describe "stack" do
        it "push にブロック指定" do
          dsl_block { board; push { mov "▲７六歩" }    }.kif_logs.count.should == 0
        end
        it "明示的に pop で戻る" do
          dsl_block { board; push;  mov "▲７六歩"; pop }.kif_logs.count.should == 0
        end
        it "pushのみ" do
          dsl_block { board; push;  mov "▲７六歩"      }.kif_logs.count.should == 1
        end
        it "スタックが空のときにpopできない" do
          expect { dsl_block { pop } }.to raise_error(HistroyStackEmpty)
        end
      end
    end
  end
end
