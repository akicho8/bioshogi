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
        player.brain.all_ways.sample.present?.should == true
      end
      it "全手筋" do
        player = player_test(:run_piece_plot => true)
        player.brain.all_ways.should == ["9六歩(97)", "8六歩(87)", "7六歩(77)", "6六歩(67)", "5六歩(57)", "4六歩(47)", "3六歩(37)", "2六歩(27)", "1六歩(17)", "3八飛(28)", "4八飛(28)", "5八飛(28)", "6八飛(28)", "7八飛(28)", "1八飛(28)", "9八香(99)", "7八銀(79)", "6八銀(79)", "7八金(69)", "6八金(69)", "5八金(69)", "6八玉(59)", "5八玉(59)", "4八玉(59)", "5八金(49)", "4八金(49)", "3八金(49)", "4八銀(39)", "3八銀(39)", "1八香(19)"]
      end
    end

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
        mediator = Mediator.new
        player = mediator.player_at(:black)

        player.initial_soldiers("１二歩", :from_piece => false)
        player.deal("歩")

        player.brain.eval_list.should == [{:way => "1一歩成(12)", :score => 1305}, {:way => "2二歩打", :score => 200}]
      end
    end

    describe "NegaMax" do
      describe "戦況1" do
        def example1
          Board.size_change([2, 3]) do
            mediator = Mediator.new
            mediator.player_at(:white).initial_soldiers(["１一香", "１二歩"], :from_piece => false)
            mediator.player_at(:black).initial_soldiers(["１三飛"], :from_piece => false)
            yield mediator
          end
        end

        it "確認" do
          example1 do |mediator|
            mediator.to_s.rstrip.should == <<-EOT.rstrip
1手目: ▲先手番
  ２ １
+------+
| ・v香|一
| ・v歩|二
| ・ 飛|三
+------+
▲先手の持駒:
▽後手の持駒:
EOT
          end
        end

        it "0手先を読む - 目先の歩得を優先してしまう" do
          example1 do |mediator|
            Brain.nega_max(:player => mediator.player_at(:black), :depth => 0).should == {:hand => "▲1二飛成(13)", :score => 2305, :level => 0}
          end
        end

        it "1手先を読む - 歩をとると飛車を取られて相手のスコアが増大するので２三飛を選択する" do
          example1 do |mediator|
            Brain.nega_max(:player => mediator.player_at(:black), :depth => 1).should == {:hand => "▲2三飛成(13)", :score => -1800, :level => 0, :hands => ["▲2三飛成(13)", "▽1三歩成(12)"]}
          end
        end
      end

      describe "戦況2" do
        def example2
          Board.disable_promotable do
            Board.size_change([1, 8]) do
              mediator = Mediator.new
              mediator.player_at(:white).initial_soldiers(["１二飛", "１三香", "１四歩"], :from_piece => false)
              mediator.player_at(:black).initial_soldiers(["１六香", "１七飛"], :from_piece => false)
              yield mediator
            end
          end
        end

        it "確認" do
          example2 do |mediator|
            mediator.to_s.rstrip.should == <<-EOT.rstrip
1手目: ▲先手番
  １
+---+
| ・|一
|v飛|二
|v香|三
|v歩|四
| ・|五
| 香|六
| 飛|七
| ・|八
+---+
▲先手の持駒:
▽後手の持駒:
EOT
          end
        end

        it "0手先の場合、駒得だけを考えて歩を取りにいく" do
          example2 do |mediator|
            p Brain.nega_max(:player => mediator.player_at(:black), :depth => 0).should == {:hand=>"▲1四香(16)", :score=>2705, :level=>0, :hands => ["▲1四香(16)"]}
          end
        end

        it "1手先の場合は歩を取ると取り返されるので飛車を移動する(相手は１一飛と１五歩をするけど両方同じ得点なのでどっちかになる曖昧)" do
          example2 do |mediator|
            Brain.nega_max(:player => mediator.player_at(:black), :depth => 1).should == {:hand=>"▲1八飛(17)", :score=>-2700, :level=>0, :hands=>["▲1八飛(17)", "▽1五歩(14)"]}
          end
        end

        it "2手先の場合は香を取り返せるところまでわかるので香がつっこむ" do
          example2 do |mediator|
            Brain.nega_max(:player => mediator.player_at(:black), :depth => 2).should == {:hand=>"▲1四香(16)", :score=>2735, :level=>0, :hands=>["▲1四香(16)", "▽1四香(13)", "▲1四飛(17)"]}
          end
        end

        it "3手先の場合は最後に飛車で取られて全滅することがわかるので香車はつっこまない" do
          example2 do |mediator|
            p Brain.nega_max(:player => mediator.player_at(:black), :depth => 3)
          end
        end

        # it "2手先の場合" do
        #   example2 do |mediator|
        #     p Brain.nega_max(:player => mediator.player_at(:black), :depth => 2)
        #   end
        # end
      end
    end

    # it "一番得するように打つその3" do
    #   Board.size_change([2, 3]) do
    #     mediator = Mediator.new
    #     mediator.player_at(:white).initial_soldiers(["１一香", "１二歩"], :from_piece => false)
    #     mediator.player_at(:black).initial_soldiers(["１三飛"], :from_piece => false)
    #     puts mediator
    #     # mediator.player_at(:black).brain.doredore
    #     p Brain.nega_max(:player => mediator.player_at(:black), :depth => 1)
    #   end
    # end

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
