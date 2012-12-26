# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Player do
    context "配置" do
      context "できる" do
        it "歩を相手の陣地に" do
          Player.test_case(:init => "5三歩").should == ["▲5三歩"]
        end
        it "成っている歩を相手の陣地に" do
          Player.test_case(:init => "5三と").should == ["▲5三と"]
        end
        it "後手が置ける" do
          Player.test_case(:init => "５五飛", :player => :white).should == ["▽5五飛↓"]
        end
      end
      context "できない" do
        it "成っている金を相手の陣地に" do
          expect { Player.test_case(:init => "5三成金").to }.to raise_error(SyntaxError)
        end
        it "すでに駒があるところに駒を配置できない" do
          expect { Player.test_case(:init => ["5三銀", "5三銀"]).to }.to raise_error(PieceAlredyExist)
        end
        it "飛車は二枚持ってないので二枚配置できない" do
          expect { Player.test_case(:init => ["5二飛", "5二飛"]) }.to raise_error(PieceNotFound)
        end
      end
    end

    describe "#setup" do
      it "初期配置" do
        board = Board.new
        players = []
        players << Player.create2(:black, board)
        players << Player.create2(:white, board)
        players.each(&:piece_plot)
        board.to_s.should == <<-FIELD.strip_heredoc
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
FIELD
      end
    end

    context "移動" do
      context "できる" do
        it "普通に" do
          Player.test_case(:init => "７七歩", :exec => "７六歩").should == ["▲7六歩"]
        end
        it "後手の歩を(画面上では下がることに注意)" do
          Player.test_case(:player => :white, :init => "３三歩", :exec => "３四歩").should == ["▽3四歩↓"]
        end
        it "成銀を" do
          Player.test_case(:init => "４二成銀", :exec => "３二成銀").should == ["▲3二全"]
        end
        it "龍を" do
          Player.test_case(:init => "４二龍", :exec => "３二龍").should == ["▲3二龍"]
        end
        it "駒の指定なしで動かす" do
          pending
        end
        it "推測結果が複数パターンあるけど移動元が明確であれば推測しないのでエラーにならない" do
          Player.test_case(:init => ["６九金", "４九金"], :exec => "５九金(49)").should == ["▲5九金", "▲6九金"]
        end
      end

      context "できない" do
        if false
          # 持駒から探す処理が入ってない場合の仕様
          it "動いてないので、と思うかもしれないけど、そこに来れる駒がないので" do
            expect { Player.test_case(:init => "４二銀", :exec => "４二銀") }.to raise_error(MovableSoldierNotFound)
          end
        end
        it "４二に来れる銀が見つからず、持駒の銀を打とうとしたが、４二にはすでに駒があった" do
          expect { Player.test_case(:init => "４二銀", :exec => "４二銀") }.to raise_error(PieceAlredyExist)
        end
        it "推測結果が複数パターンがあったので" do
          expect { Player.test_case(:init => ["６九金", "４九金"], :exec => "５九金") }.to raise_error(AmbiguousFormatError)
        end
        it "成っている状態から成らない状態に戻ろうとしたので" do
          expect { Player.test_case(:init => "５五龍", :exec => "５六飛") }.to raise_error(PromotedPieceToNormalPiece)
        end
        it "元の駒を明示してたとしても、成っている状態から成らない状態に戻ることは" do
          expect { Player.test_case(:init => "５五龍", :exec => "５六飛(55)") }.to raise_error(PromotedPieceToNormalPiece)
        end
      end

      context "成" do
        context "成れる" do
          it "相手陣地に入るときに成る" do
            Player.test_case(:init => "２四歩", :exec => "２三歩成").should == ["▲2三と"]
          end
          it "相手陣地から出るときに成る" do
            Player.test_case(:init => "５一飛", :exec => "５四飛成").should == ["▲5四龍"]
          end
          it "後手が相手の3段目に入ったタイミングで成る(バグっていたので消さないように)" do
            Player.test_case(:player => :white, :init => "４五桂", :exec => "５七桂成").should == ["▽5七圭↓"]
          end
        end
        context "成れない" do
          it "自分の陣地に入るタイミングでは" do
            expect { Player.test_case(:init => "５五飛", :exec => "５九飛成") }.to raise_error(NotPromotable)
          end
          it "自分の陣地から出るタイミングでも" do
            expect { Player.test_case(:init => "５九飛", :exec => "５五飛成") }.to raise_error(NotPromotable)
          end
          it "天王山から一歩動いただけじゃ" do
            expect { Player.test_case(:init => "５五飛", :exec => "５六飛成") }.to raise_error(NotPromotable)
          end
          it "すでに成っているから" do
            expect { Player.test_case(:init => "５五龍", :exec => "５一飛成") }.to raise_error(AlredyPromoted)
          end
        end
      end

      context "不成" do
        context "できる" do
          it "成と明示しなかったので" do
            Player.test_case(:init => "５五桂", :exec => "４三桂").should == ["▲4三桂"]
          end
          it "不成の指定をしたので" do
            Player.test_case(:init => "５五桂", :exec => "４三桂不成").should == ["▲4三桂"]
          end
        end
        context "できない" do
          it "移動できる見込みがないとき" do
            expect { Player.test_case(:init => "５三桂", :exec => "４一桂") }.to raise_error(NotPutInPlaceNotBeMoved)
          end
        end
      end

      context "取る" do
        context "取れる" do
          it "座標指定で" do
            # FIXME: Frame のクラスメソッドにする
            frame = Frame.sit_down
            frame.players[0].initial_put_on("５六歩")
            frame.players[1].initial_put_on("５五飛")
            frame.piece_discard
            frame.players[0].execute("５五歩")
            frame.players[0].piece_names.should == ["飛"]
          end
          it "同歩で取る" do
            frame = Frame.sit_down
            frame.players[0].initial_put_on("２五歩")
            frame.players[1].initial_put_on("２三歩")
            frame.piece_discard
            frame.players[0].execute("２四歩")
            frame.players[1].execute("同 歩")
            frame.players[1].piece_names.should == ["歩"]
          end
        end
        context "取れない" do
          # MEMO: 相手がいないと同角は失敗するので「相手がいない」というエラーすることも検討
          it "一人で同を使う(同角で２五がわかった上で移動しようとしたけど自分の飛車がいるために移動できなかった)" do
            expect { Player.test_case(:init => ["２五飛", "８八角"], :exec => ["５五飛", "同角"]) }.to raise_error(MovableSoldierNotFound, /5五に移動できる角がありません/)
          end
          it "初手に同歩" do
            expect { Player.test_case(:exec => "同歩") }.to raise_error(BeforePointNotFound)
          end
        end

        # context "後手で同金直" do
        #   it do
        #     frame = Frame.sit_down
        #     frame.players[0].initial_put_on("５六金")
        #     frame.players[1].initial_put_on(["５四金", "６四金"])
        #     frame.piece_discard
        #     frame.players[0].execute("５五金")
        #     frame.players[1].execute("同金直") # これが５四金を指すか６四金か指すかで迷うが、５四金が正解
        #     frame.players[1].piece_names.should == ["金"]
        #     frame.players[1].last_a_move.should == "5五金(54)"
        #
        #     # p Player.test_case2(:init => ["２五飛", "８八角"], :exec => ["５五飛", "同角"]).last_a_move
        #     # expect {  }.to raise_error(MovableSoldierNotFound, /5五に移動できる角がありません/)
        #   end
        # end
      end
    end

    context "打つ" do
      context "打てる" do
        it "空いているところに" do
          Player.test_case(:exec => "５五歩打").should == ["▲5五歩"]
        end

        # 棋譜の表記方法：日本将棋連盟 http://www.shogi.or.jp/faq/kihuhyouki.html
        # > ※「打」と記入するのはあくまでもその地点に盤上の駒を動かすこともできる場合のみです。それ以外の場合は、持駒を打つ場合も「打」はつけません。
        it "打は曖昧なときだけ付く" do
          Player.test_case(:exec => "５五歩").should == ["▲5五歩"]
          Player.test_case2(:exec => "５五歩").last_a_move.should == "5五歩打"
        end

        it "と金は二歩にならないので" do
          Player.test_case(:init => "５五と", :exec => "５六歩打").should == ["▲5五と", "▲5六歩"]
        end
      end

      context "打てない" do
        it "場外に" do
          expect { Player.test_case(:exec => "５十飛打") }.to raise_error(UnknownPositionName)
        end
        it "自分の駒の上に" do
          expect { Player.test_case(:init => "５五飛", :exec => "５五角打") }.to raise_error(PieceAlredyExist)
        end
        it "相手の駒の上に" do
          frame = Frame.sit_down
          frame.players[1].initial_put_on("５五飛")
          expect { frame.players[0].execute("５五角打") }.to raise_error(PieceAlredyExist)
        end
        it "卍という駒がないので" do
          expect { Player.test_case(:exec => "５五卍打") }.to raise_error(SyntaxError)
        end
        it "成った状態で" do
          expect { Player.test_case(:exec => "５五龍打") }.to raise_error(PromotedPiecePutOnError)
        end
        it "１一歩打だとそれ以上動けないので" do
          expect { Player.test_case(:exec => "１一歩打") }.to raise_error(NotPutInPlaceNotBeMoved)
        end
        it "二歩なので" do
          expect { Player.test_case(:init => "５五歩", :exec => "５九歩打") }.to raise_error(DoublePawn)
        end
      end
    end

    context "人間が入力する棋譜" do
      before do
        @params = {
          # :player => :white,
          :deal => "飛" * 7,
          # # "６四龍", "５四龍", "４四龍",
          # # "６五龍",           "４五龍",
          # "６六龍", "５六龍", "４六龍",
        }
      end

      # it("左下から右上") { Player.test_case2(:init => ["６六金", "４六金"], :exec => "５五金左").last_a_move.should == "5五金(66)" }
      # it("右下から左上") { Player.test_case2(:init => ["６六金", "４六金"], :exec => "５五金右").last_a_move.should == "5五金(46)" }
      #
      # # it("右上から左下") { Player.test_case2(:init => ["６四銀", "４四銀"], :exec => "５五銀引").last_a_move.should == "5五銀(44)" }
      # # it("左上から右下") { Player.test_case2(:init => ["６四銀", "４四銀"], :exec => "５五銀左").last_a_move.should == "5五銀(44)" }
      # # it("左上から右下") { Player.test_case2(:init => ["６四銀", "４四銀"], :exec => "５五銀引").last_a_move.should == "5五銀(44)" }
      #
      # it("左上から右下") { Player.test_case2(:init => ["６六金", "４六金"], :exec => "５五金右").last_a_move.should == "5五金(46)" }
      # it("左から右")     { Player.test_case2(:init => ["６五金", "４五金"], :exec => "５五金左").last_a_move.should == "5五金(65)" }
      # it("右から左")     { Player.test_case2(:init => ["６五金", "４五金"], :exec => "５五金右").last_a_move.should == "5五金(45)" }
      # it("真下から真上") { Player.test_case2(:init => ["５四金", "５六金"], :exec => "５五金直").last_a_move.should == "5五金(56)" }
      # it("真上から真下") { Player.test_case2(:init => ["５四金", "５六金"], :exec => "５五金引").last_a_move.should == "5五金(54)" }

      # it "後手で直" do
      #   Player.test_case2(:player => :white, :init => ["５四金", "６四金"], :exec => "５五金直").last_a_move.should == "5五金(54)"
      # end

      context "龍と馬は例外" do
        before do
          @params.update({:init => [
                nil, "６四龍", "５四龍", nil,
                nil, nil, nil, nil,
              ]})
        end
        it { Player.test_case2(@params.merge(:exec => "５五龍左")).last_a_move.should == "5五龍(64)" }
        it { Player.test_case2(@params.merge(:exec => "５五龍右")).last_a_move.should == "5五龍(54)" }
      end

      # http://www.shogi.or.jp/faq/kihuhyouki.html
      context "龍" do
        context "パターンA" do
          before{ @params.update(:init => ["９一龍", "８四龍"]) }
          it { Player.test_case2(@params.merge(:exec => "８二龍引")).last_a_move.should == "8二龍(91)" }
          it { Player.test_case2(@params.merge(:exec => "８二龍上")).last_a_move.should == "8二龍(84)" }
        end
        context "パターンB" do
          before{ @params.update(:init => ["５二龍", "２三龍"]) }
          it { Player.test_case2(@params.merge(:exec => "４三龍寄")).last_a_move.should == "4三龍(23)" }
          it { Player.test_case2(@params.merge(:exec => "４三龍引")).last_a_move.should == "4三龍(52)" }
        end
        context "パターンC" do
          before{ @params.update(:init => ["５五龍", "１五龍"]) }
          it { Player.test_case2(@params.merge(:exec => "３五龍左")).last_a_move.should == "3五龍(55)" }
          it { Player.test_case2(@params.merge(:exec => "３五龍右")).last_a_move.should == "3五龍(15)" }
        end
        context "パターンD" do
          before{ @params.update(:init => ["９九龍", "８九龍"]) }
          it { Player.test_case2(@params.merge(:exec => "８八龍左")).last_a_move.should == "8八龍(99)" }
          it { Player.test_case2(@params.merge(:exec => "８八龍右")).last_a_move.should == "8八龍(89)" }
        end
        context "パターンE" do
          before{ @params.update(:init => ["２八龍", "１九龍"]) }
          it { Player.test_case2(@params.merge(:exec => "１七龍左")).last_a_move.should == "1七龍(28)" }
          it { Player.test_case2(@params.merge(:exec => "１七龍右")).last_a_move.should == "1七龍(19)" }
        end
      end

      context "下面" do
        before do
          @params.update({:init => [
                nil,      nil,      nil,
                nil,      nil,      nil,
                "６六と", "５六と", "４六と",
              ]})
        end
        it("右下の") { Player.test_case2(@params.merge(:exec => "５五と右")).last_a_move.should == "5五と(46)" }
        it("真下の") { Player.test_case2(@params.merge(:exec => "５五と直")).last_a_move.should == "5五と(56)" }
        it("左下の") { Player.test_case2(@params.merge(:exec => "５五と左")).last_a_move.should == "5五と(66)" }
      end
      context "左面" do
        before do
          @params.update({:init => [
                "６四龍", nil, nil,
                "６五龍", nil, nil,
                "６六龍", nil, nil,
              ]})
        end
        it("左上の") { Player.test_case2(@params.merge(:exec => "５五龍左引")).last_a_move.should == "5五龍(64)" }
        it("真左の") { Player.test_case2(@params.merge(:exec => "５五龍寄")).last_a_move.should   == "5五龍(65)" }
        it("左下の") { Player.test_case2(@params.merge(:exec => "５五龍左上")).last_a_move.should == "5五龍(66)" }
      end
      context "右面" do
        before do
          @params.update({:init => [
                nil, nil, "４四龍",
                nil, nil, "４五龍",
                nil, nil, "４六龍",
              ]})
        end
        it("右上の") { Player.test_case2(@params.merge(:exec => "５五龍右引")).last_a_move.should == "5五龍(44)" }
        it("真右の") { Player.test_case2(@params.merge(:exec => "５五龍寄")).last_a_move.should   == "5五龍(45)" }
        it("右下の") { Player.test_case2(@params.merge(:exec => "５五龍右上")).last_a_move.should == "5五龍(46)" }
      end

      # この場合 "４七銀引" は３六の銀が斜め左下に移動する
      #
      #     ９ ８ ７ ６ ５ ４ ３ ２ １
      #   +---------------------------+
      #   |v香 ・ ・ ・ ・v歩v玉 ・v香|一
      #   | ・ ・ ・ ・ 圭v銀v金v角 ・|二
      #   | ・ ・ ・ とv歩 ・v歩v歩v桂|三
      #   |v歩 ・ ・v歩 ・ ・ ・ ・v歩|四
      #   | ・v歩 ・ ・ ・ ・ 歩v銀 ・|五
      #   | 歩 ・ ・ ・ ・ ・ 銀 ・ 歩|六
      #   |vと ・ ・ ・ 歩 ・ 角 歩 ・|七
      #   | ・ ・ ・ 歩 ・ ・ 銀 玉 ・|八
      #   | ・ 桂v龍 ・ ・ 金 ・ 桂 香|九
      #   +---------------------------+
      it "引で斜めに引く" do
        Player.test_case2(:init => ["３六銀", "３八銀"], :exec => "４七銀引").last_a_move.should == "4七銀(36)"
      end
    end

    it "指したあと前回の手を確認できる" do
      Player.test_case2(:init => "５五飛", :exec => "５一飛成").last_a_move.should == "5一飛成(55)"
      Player.test_case2(:init => "５一龍", :exec => "１一龍").last_a_move.should   == "1一龍(51)"
      Player.test_case2(:exec => "５五飛打").last_a_move.should                    == "5五飛打"
    end

    it "全体確認" do
      board = Board.new
      players = []
      players << Player.create2(:black, board)
      players << Player.create2(:white, board)
      players.each(&:piece_plot)
      players[0].execute("7六歩")
      players[1].execute("3四歩")
      players[0].execute("2二角成")
      players[0].pieces.collect(&:name).should == ["角"]
      board.to_s.should == <<-FIELD.strip_heredoc
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
FIELD
    end
  end
end
