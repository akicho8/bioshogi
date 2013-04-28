# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Brain do
    describe "評価" do
      it "駒を置いてないとき" do
        player_test.evaluate.should == 22284
      end
      it "駒を置いているとき" do
        player_test(:run_piece_plot => true).evaluate.should == 21699
      end
    end

    describe "自動的に打つ" do
      it "ランダムに盤上の駒を動かす" do
        player = player_test(:run_piece_plot => true)
        player.generate_way.present?.should == true
      end
      it "全手筋" do
        player = player_test(:run_piece_plot => true)
        player.brain.all_ways.should == ["9六歩(97)", "8六歩(87)", "7六歩(77)", "6六歩(67)", "5六歩(57)", "4六歩(47)", "3六歩(37)", "2六歩(27)", "1六歩(17)", "3八飛(28)", "4八飛(28)", "5八飛(28)", "6八飛(28)", "7八飛(28)", "1八飛(28)", "9八香(99)", "7八銀(79)", "6八銀(79)", "7八金(69)", "6八金(69)", "5八金(69)", "6八玉(59)", "5八玉(59)", "4八玉(59)", "5八金(49)", "4八金(49)", "3八金(49)", "4八銀(39)", "3八銀(39)", "1八香(19)"]
      end
    end

    describe "Brain" do
      it "盤上の駒の全手筋" do
        Board.size_change([3, 3]) do
          player = player_test(:init => ["1二歩", "2三桂"])
          player.brain.soldiers_ways.should == ["1一歩成(12)", "3一桂成(23)", "1一桂成(23)"]
        end
      end

      it "持駒の全手筋" do
        #
        # この状態↓から打てるのはこれ↓
        #
        #   ３ ２ １         ３ ２ １
        # +---------+      +---------+
        # | ・ ・ ・|一    | ・ ・ ・|一
        # | ・ 歩 ・|二 → | 歩 ・ 歩|二
        # | ・ ・ ・|三    | 歩 ・ 歩|三
        # +---------+      +---------+
        #
        Board.size_change([3, 3]) do
          player = player_test(:init => "２二歩", :reset_pieces => "歩")
          player.brain.pieces_ways.should == ["3二歩打", "1二歩打", "3三歩打", "1三歩打"]
        end
      end

      it "一番得するように打つ" do
        Board.size_change([2, 2]) do
          # Board.size_change([2, 2])
          # player = player_test(:init => "２二歩", :pieces => "歩 香")
          # player.brain.eval_list.should == [{:way => "2一歩成(22)", :score => 1935}, {:way => "1二歩打", :score => 830}, {:way => "1二香打", :score => 805}]
          # player.brain.best_way.should == "2一歩成(22)"

          # Board.size_change([2, 2])
          mediator = Mediator.new
          player = mediator.player_at(:black)

          player.initial_soldiers("１二歩", :from_piece => false)
          player.deal("歩")

          player.brain.eval_list.should == [{:way => "1一歩成(12)", :score => 1305}, {:way => "2二歩打", :score => 200}]
        end
      end
    end

    # describe "一時的に置いてみた状態にする" do
    #   it "safe_put_on" do
    #     player = player_test(:init => "２二歩", :reset_pieces => "歩")
    #     p player.to_s_soldiers
    #     p player.to_s_pieces
    #     player.safe_put_on("１二歩打") do
    #       p player.to_s_soldiers
    #       p player.to_s_pieces
    #     end
    #     p player.to_s_soldiers
    #     p player.to_s_pieces
    #
    #     # player = player_test
    #     # player.to_s_pieces.should == "歩九 角 飛 香二 桂二 銀二 金二 玉"
    #     # player.safe_put_on("5五飛") do
    #     #   player.to_s_pieces.should == "歩九 角 香二 桂二 銀二 金二 玉"
    #     #   player.safe_put_on("4五角") do
    #     #     player.to_s_pieces.should == "歩九 香二 桂二 銀二 金二 玉"
    #     #   end
    #     #   player.to_s_pieces.should == "歩九 香二 桂二 銀二 金二 玉 角"
    #     # end
    #     # player.to_s_pieces.should == "歩九 香二 桂二 銀二 金二 玉 角 飛"
    #
    #     # player = player_test(:init => "２二歩", :reset_pieces => "歩")
    #     # p player.to_s_soldiers
    #     # p player.to_s_pieces
    #     # player.safe_put_on("１二歩打") do
    #     #   p player.to_s_soldiers
    #     #   p player.to_s_pieces
    #     # end
    #     # p player.to_s_soldiers
    #     # p player.to_s_pieces
    #   end
    # end

    # it "復元するのは持駒と盤上の駒のみ(boardはmediator経由)" do # FIXME: なんのテストなのかよくわからない
    #   player1 = player_test(:init => "５九玉", :exec => "５八玉")
    #   player1.soldier_names.should == ["▲5八玉"]
    #   player1.to_s_pieces.should == "歩九 角 飛 香二 桂二 銀二 金二"
    #
    #   player2 = Marshal.load(Marshal.dump(player1))
    #   player2.soldier_names.should == ["▲5八玉"]
    #   player2.to_s_pieces.should == "歩九 角 飛 香二 桂二 銀二 金二"
    #   # player2.board.present?.should == true # @mediator が nil になっている
    # end

    # it "サンドボックス実行(インスタンスを作り直すわけではないので @board は残っている。というか更新されたまま…)" do
    #   player = player_test(:init => "１二歩", :reset_pieces => "歩")
    #   player.to_s_soldiers.should == "1二歩"
    #   player.to_s_pieces.should == "歩"
    #   player.board.to_s_soldiers.should == "1二歩"
    #   player.sandbox_for { player.execute("２二歩打") }
    #   player.to_s_soldiers.should == "1二歩"
    #   player.to_s_pieces.should == "歩"
    #   player.board.present?.should == true
    #   player.board.to_s_soldiers.should == "1二歩 2二歩" # ← こうなるのが問題
    # end

    # it "フレームのサンドボックス実行(FIXME:もっと小さなテストにする)" do
    #   mediator = Mediator.test(:init => ["１二歩"])
    #   mediator.player_at(:black).to_s_soldiers.should == "1二歩"
    #   # mediator.player_at(:black).to_s_pieces.should == "歩八 角 飛 香二 桂二 銀二 金二 玉"
    #   # mediator.player_at(:black).board.to_s_soldiers.should == "1二歩"
    #
    #   # puts mediator.board
    #   mediator.sandbox_for { mediator.player_at(:black).execute("２二歩打") }
    #   # puts mediator.board
    #
    #   mediator.player_at(:black).to_s_soldiers.should == "1二歩"
    #
    #   # mediator.player_at(:black).to_s_pieces.should == "歩八 角 飛 香二 桂二 銀二 金二 玉"
    #   # mediator.player_at(:black).board.present?.should == true
    #   # mediator.player_at(:black).board.to_s_soldiers.should == "1二歩" # ← こうなるのが問題
    # end
  end
end
