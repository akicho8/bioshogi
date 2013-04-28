# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Player do
    it "持駒を参照する" do
      player_test.piece_fetch(Piece["歩"]).name.should == "歩"
    end

    describe "駒を配る" do
      it "平手のデフォルト" do
        player_test.to_s_pieces.should == "歩九 角 飛 香二 桂二 銀二 金二 玉"
      end
      it "任意" do
        player_test(:initial_deal => false, :append_pieces => "飛 歩二").to_s_pieces.should == "飛 歩二"
      end
    end

    describe "配置" do
      describe "できる" do
        it "歩を相手の陣地に" do
          player_test2(:init => "5三歩").should == ["▲5三歩"]
        end
        it "成っている歩を相手の陣地に" do
          player_test2(:init => "5三と").should == ["▲5三と"]
        end
        it "後手が置ける" do
          player_test2(:init => "５五飛", :player => :white).should == ["▽5五飛"]
        end
      end
      describe "できない" do
        it "成っている金を相手の陣地に" do
          expect { player_test2(:init => "5三成金").to }.to raise_error(SyntaxError)
        end
        it "すでに駒があるところに駒を配置できない" do
          expect { player_test2(:init => ["5三銀", "5三銀"]).to }.to raise_error(PieceAlredyExist)
        end
        it "飛車は二枚持ってないので二枚配置できない" do
          expect { player_test2(:init => ["5二飛", "5二飛"]) }.to raise_error(PieceNotFound)
        end
      end
    end

    it "初期配置" do
      mediator = Mediator.start
      mediator.piece_plot
      mediator.board.to_s.should == <<-EOT.strip_heredoc
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金v銀v桂v香|一
| ・v飛 ・ ・ ・ ・ ・v角 ・|二
|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 銀 桂 香|九
+---------------------------+
EOT
    end

    describe "移動" do
      describe "できる" do
        it "普通に" do
          player_test2(:init => "７七歩", :exec => "７六歩").should == ["▲7六歩"]
        end
        it "後手の歩を(画面上では下がることに注意)" do
          player_test2(:player => :white, :init => "３三歩", :exec => "３四歩").should == ["▽3四歩"]
        end
        it "成銀を" do
          player_test2(:init => "４二成銀", :exec => "３二成銀").should == ["▲3二全"]
        end
        it "龍を" do
          player_test2(:init => "４二龍", :exec => "３二龍").should == ["▲3二龍"]
        end
        it "駒の指定なしで動かす" do
          # 初手 "７六" とした場合、そこに来れるのは真下の、"歩" のみなので "７六歩" とする
          # というのはやりすぎなので保留
        end
        it "推測結果が複数パターンあるけど移動元が明確であれば推測しないのでエラーにならない" do
          player_test2(:init => ["６九金", "４九金"], :exec => "５九金(49)").should == ["▲5九金", "▲6九金"]
        end
        describe "「と」と「歩」が縦列にある状態でどちらを進めても二歩にならない" do
          it "とを進める" do
            player_test2(:init => ["１二と", "１四歩"], :exec => "１三歩").should == ["▲1三歩", "▲1二と"]
          end
          it "歩を進める" do
            player_test2(:init => ["１二と", "１四歩"], :exec => "１一と").should == ["▲1一と", "▲1四歩"]
          end
        end
      end

      describe "できない" do
        it "４二に移動できる銀が見つからず、持駒の銀を打とうとしたが、４二にはすでに駒があったので" do
          expect { player_test2(:init => "４二銀", :exec => "４二銀") }.to raise_error(PieceAlredyExist)
        end
        it "推測結果が複数パターンがあったので" do
          expect { player_test2(:init => ["６九金", "４九金"], :exec => "５九金") }.to raise_error(AmbiguousFormatError)
        end
        it "ルール上、成っている状態から成らない状態に戻れないので(盤上に飛が見つからないので)" do
          expect { player_test2(:init => "５五龍", :exec => "５六飛") }.to raise_error(MovableSoldierNotFound)
        end
        it "ルール上、成っている状態から成らない状態に戻れないので(移動元を明記しても同様。ただ例外の種類が異なる)" do
          expect { player_test2(:init => "５五龍", :exec => "５六飛(55)") }.to raise_error(PromotedPieceToNormalPiece)
        end
      end

      describe "成" do
        describe "成れる" do
          it "相手陣地に入るときに成る" do
            player_test2(:init => "２四歩", :exec => "２三歩成").should == ["▲2三と"]
          end
          it "相手陣地から出るときに成る" do
            player_test2(:init => "５一飛", :exec => "５四飛成").should == ["▲5四龍"]
          end
          it "後手が相手の3段目に入ったタイミングで成る(バグっていたので消さないように)" do
            player_test2(:player => :white, :init => "４五桂", :exec => "５七桂成").should == ["▽5七圭"]
          end
        end
        describe "成れない" do
          it "自分の陣地に入るタイミングでは" do
            expect { player_test2(:init => "５五飛", :exec => "５九飛成") }.to raise_error(NotPromotable)
          end
          it "自分の陣地から出るタイミングでも" do
            expect { player_test2(:init => "５九飛", :exec => "５五飛成") }.to raise_error(NotPromotable)
          end
          it "天王山から一歩動いただけじゃ" do
            expect { player_test2(:init => "５五飛", :exec => "５六飛成") }.to raise_error(NotPromotable)
          end
          it "飛がないので" do
            expect { player_test2(:init => "５五龍", :exec => "５一飛成") }.to raise_error(MovableSoldierNotFound)
          end
        end
      end

      describe "不成" do
        describe "できる" do
          it "成を明示しなかったので" do
            player_test2(:init => "５五桂", :exec => "４三桂").should == ["▲4三桂"]
          end
          it "不成の指定をしたので" do
            player_test2(:init => "５五桂", :exec => "４三桂不成").should == ["▲4三桂"]
          end
          describe "金が不成するケース" do
            it "不成の指定をしたけど金は不成しかないのでまちがっちゃいないけど「金不成」と棋譜が残るのは違和感がある" do
              expect { player_test(:init => "１四金", :exec => "１三金不成") }.to raise_error(NoPromotablePiece)
            end
            it "不成の指定をしなかった" do
              player_test(:init => "１四金", :exec => "１三金").runner.hand_log.to_pair.should== ["1三金(14)", "1三金"]
            end
          end
        end
        describe "できない" do
          it "移動できる見込みがないとき" do
            expect { player_test2(:init => "５三桂", :exec => "４一桂") }.to raise_error(NotPutInPlaceNotBeMoved)
          end
        end
      end

      describe "取る" do
        describe "取れる" do
          it "座標指定で" do
            mediator = Mediator.test(:init => [["１五玉", "１四歩"], ["１一玉", "１二歩"]], :exec => ["１三歩成", "１三歩"])
            mediator.prev_player.last_piece.name.should == "歩"
            mediator.prev_player.to_s_pieces.should == "歩九 角 飛 香二 桂二 銀二 金二"
            mediator.prev_player.to_s_soldiers.should == "1一玉 1三歩"
            mediator.current_player.to_s_pieces.should == "歩八 角 飛 香二 桂二 銀二 金二"
            mediator.current_player.to_s_soldiers.should == "1五玉"
          end
          it "同歩で取る" do
            mediator = Mediator.test(:init => ["２五歩", "２三歩"], :exec => ["２四歩", "同歩"])
            mediator.hand_logs.last.to_pair.should == ["2四歩(23)", "同歩"]

            mediator.prev_player.last_piece.name.should == "歩"
            mediator.prev_player.to_s_pieces.should == "歩九 角 飛 香二 桂二 銀二 金二 玉"
            mediator.prev_player.to_s_soldiers.should == "2四歩"
            mediator.current_player.to_s_pieces.should == "歩八 角 飛 香二 桂二 銀二 金二 玉"
            mediator.current_player.to_s_soldiers.should == ""
          end
          it "「同歩」ではなくわかりやすく「２四同歩」とした場合" do
            mediator = Mediator.test(:init => ["２五歩", "２三歩"], :exec => ["２四歩", "２四同歩"])
            mediator.hand_logs.last.to_pair.should == ["2四歩(23)", "同歩"]
          end
          it "２五の地点にたたみ掛けるときki2形式で同が連続すること" do
            mediator = Mediator.test(:init => [["２七歩", "２八飛"], ["２三歩", "２二飛"]], :exec => ["２六歩", "２四歩", "２五歩", "同歩", "同飛", "同飛"])
            mediator.human_hand_logs.should == ["▲2六歩", "▽2四歩", "▲2五歩", "▽同歩", "▲同飛", "▽同飛"]
          end
        end

        describe "取れない" do
          it "初手に同歩" do
            expect { Mediator.test(:exec => "同歩") }.to raise_error(BeforePointNotFound, /同に対する座標が不明です/)
          end
          it "一人で同を使った場合、その座標は自分の駒があるため、その上に移動することはできず、そこに移動できる駒がないエラーになる" do
            expect { Mediator.test(:nplayers => 1, :init => ["１九香", "１八香"], :exec => ["１五香", "同香"]) }.to raise_error(MovableSoldierNotFound)
          end
        end
      end
    end

    describe "打つ" do
      describe "打てる" do
        it "空いているところに" do
          player_test2(:exec => "５五歩打").should == ["▲5五歩"]
        end

        # 棋譜の表記方法：日本将棋連盟 http://www.shogi.or.jp/faq/kihuhyouki.html
        # > ※「打」と記入するのはあくまでもその地点に盤上の駒を動かすこともできる場合のみです。それ以外の場合は、持駒を打つ場合も「打」はつけません。
        it "打は曖昧なときだけ付く" do
          player_test2(:exec => "５五歩").should == ["▲5五歩"]
          player_test(:exec => "５五歩").runner.hand_log.to_s_simple.should == "5五歩打"
        end

        it "２二角成としたけど盤上に何もないので持駒の角を打った(打てていたけど、成と書いて打てるのはおかしいのでエラーとする)" do
          expect { player_test(:exec => ["２二角成"]) }.to raise_error(IllegibleFormat)
        end

        it "盤上に竜があってその横に飛を「打」をつけずに打った(打つときに他の駒もそこに来れそうなケース。実際は竜なので来れない)" do
          player_test(:append_pieces => "飛", :init => "１一龍", :exec => "２一飛").runner.hand_log.to_s_simple.should == "2一飛打"
        end

        it "と金は二歩にならないので" do
          player_test2(:init => "５五と", :exec => "５六歩打").should == ["▲5五と", "▲5六歩"]
        end
      end

      describe "打てない" do
        it "場外に" do
          expect { player_test2(:exec => "５十飛打") }.to raise_error(SyntaxError)
        end
        it "自分の駒の上に" do
          expect { player_test2(:init => "５五飛", :exec => "５五角打") }.to raise_error(PieceAlredyExist)
        end
        it "相手の駒の上に" do
          expect { Mediator.test(:exec => ["５五飛打", "５五角打"]) }.to raise_error(PieceAlredyExist)
        end
        it "卍という駒がないので" do
          expect { player_test2(:exec => "５五卍打") }.to raise_error(SyntaxError)
        end
        it "成った状態で" do
          expect { player_test2(:exec => "５五龍打") }.to raise_error(PromotedPiecePutOnError)
        end
        it "１一歩打だとそれ以上動けないので" do
          expect { player_test2(:exec => "１一歩打") }.to raise_error(NotPutInPlaceNotBeMoved)
        end
        it "二歩なので" do
          expect { player_test2(:init => "５五歩", :exec => "５九歩打") }.to raise_error(DoublePawn)
        end
      end
    end

    it "指したあと前回の手を確認できる" do
      player_test(:init => "５五飛", :exec => "５一飛成").runner.hand_log.to_s_simple.should == "5一飛成(55)"
      player_test(:init => "５一龍", :exec => "１一龍").runner.hand_log.to_s_simple.should   == "1一龍(51)"
      player_test(:exec => "５五飛打").runner.hand_log.to_s_simple.should                    == "5五飛打"
    end

    it "持駒の確認" do
      player_test.to_s_pieces.should == "歩九 角 飛 香二 桂二 銀二 金二 玉"
    end

    it "piece_plot" do
      player = Bushido::Mediator.new.black_player
      player.deal
      player.piece_plot
    end

    it "全体確認" do
      mediator = Mediator.start
      mediator.piece_plot
      mediator.execute("7六歩")
      mediator.execute("3四歩")
      mediator.execute("2二角成")
      mediator.player_at(:black).to_s_pieces.should == "角"
      mediator.board.to_s.should == <<-EOT.strip_heredoc
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金v銀v桂v香|一
| ・v飛 ・ ・ ・ ・ ・ 馬 ・|二
|v歩v歩v歩v歩v歩v歩 ・v歩v歩|三
| ・ ・ ・ ・ ・ ・v歩 ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ 歩 ・ ・ ・ ・ ・ ・|六
| 歩 歩 ・ 歩 歩 歩 歩 歩 歩|七
| ・ ・ ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 銀 桂 香|九
+---------------------------+
EOT
    end

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
        player.brain.generate_way.present?.should == true
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
