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
