# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe KifuDsl do
    it "試行錯誤用" do
      builder = KifuDsl.build do
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
      def seq_test(&block)
        builder = KifuDsl.build(&block)
        @sequencer = Sequencer.new
        @sequencer.pattern = builder
        @sequencer.evaluate
        @sequencer
      end

      it "title" do
        seq_test{ title "(title)" }.variables[:title].should   == "(title)"
      end

      it "comment" do
        seq_test{ comment "(comment)" }.variables[:comment].should == "(comment)"
      end

      it "board" do
        seq_test{ board "平手" }.board
        seq_test{ board }.board
      end

      it "mov" do
        seq_test{ board; mov "▲７六歩" }
      end

      it "pieces" do
        seq_test{ pieces "▲" => "歩1 桂2" }.player_at("▲").to_s_pieces.should == "歩 桂二"
      end

      describe "stack" do
        it "push にブロック指定" do
          seq_test { board; push { mov "▲７六歩" }    }.simple_kif_logs.count.should == 0
        end
        it "明示的に pop で戻る" do
          seq_test { board; push;  mov "▲７六歩"; pop }.simple_kif_logs.count.should == 0
        end
        it "pushのみ" do
          seq_test { board; push;  mov "▲７六歩"      }.simple_kif_logs.count.should == 1
        end
        it "スタックが空のときにpopできない" do
          expect { seq_test { pop } }.to raise_error(HistroyStackEmpty)
        end
      end
    end
  end
end
