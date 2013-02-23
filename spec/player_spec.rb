# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Player do
    it "持駒を参照する" do
      player = Player.new
      player.deal
      player.piece_fetch(Piece["歩"]).name == "歩"
    end

    it "駒を配る" do
      player = Player.new
      player.to_s_pieces.should == ""
      player.deal("飛 歩二")
      player.to_s_pieces.should == "飛 歩二"
      player.pieces.clear
      player.deal
      player.to_s_pieces.should == "歩九 角 飛 香二 桂二 銀二 金二 玉"
    end

    context "配置" do
      context "できる" do
        it "歩を相手の陣地に" do
          Player.basic_test2(:init => "5三歩").should == ["▲5三歩"]
        end
        it "成っている歩を相手の陣地に" do
          Player.basic_test2(:init => "5三と").should == ["▲5三と"]
        end
        it "後手が置ける" do
          Player.basic_test2(:init => "５五飛", :player => :white).should == ["▽5五飛"]
        end
      end
      context "できない" do
        it "成っている金を相手の陣地に" do
          expect { Player.basic_test2(:init => "5三成金").to }.to raise_error(SyntaxError)
        end
        it "すでに駒があるところに駒を配置できない" do
          expect { Player.basic_test2(:init => ["5三銀", "5三銀"]).to }.to raise_error(PieceAlredyExist)
        end
        it "飛車は二枚持ってないので二枚配置できない" do
          expect { Player.basic_test2(:init => ["5二飛", "5二飛"]) }.to raise_error(PieceNotFound)
        end
      end
    end

    it "初期配置" do
      board = Board.new
      players = []
      players << Player.create2(:black, board)
      players << Player.create2(:white, board)
      players.each(&:piece_plot)
      board.to_s.should == <<-EOT.strip_heredoc
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

    context "移動" do
      context "できる" do
        it "普通に" do
          Player.basic_test2(:init => "７七歩", :exec => "７六歩").should == ["▲7六歩"]
        end
        it "後手の歩を(画面上では下がることに注意)" do
          Player.basic_test2(:player => :white, :init => "３三歩", :exec => "３四歩").should == ["▽3四歩"]
        end
        it "成銀を" do
          Player.basic_test2(:init => "４二成銀", :exec => "３二成銀").should == ["▲3二全"]
        end
        it "龍を" do
          Player.basic_test2(:init => "４二龍", :exec => "３二龍").should == ["▲3二龍"]
        end
        it "駒の指定なしで動かす" do
          # 初手 "７六" とした場合、そこに来れるのは真下の、"歩" のみなので "７六歩" とする
          # というのはやりすぎなので保留
        end
        it "推測結果が複数パターンあるけど移動元が明確であれば推測しないのでエラーにならない" do
          Player.basic_test2(:init => ["６九金", "４九金"], :exec => "５九金(49)").should == ["▲5九金", "▲6九金"]
        end
        context "「と」と「歩」が縦列にある状態でどちらを進めても二歩にならない" do
          it "とを進める" do
            Player.basic_test2(:init => ["１二と", "１四歩"], :exec => "１三歩").should == ["▲1三歩", "▲1二と"]
          end
          it "歩を進める" do
            Player.basic_test2(:init => ["１二と", "１四歩"], :exec => "１一と").should == ["▲1一と", "▲1四歩"]
          end
        end
      end

      context "できない" do
        it "４二に移動できる銀が見つからず、持駒の銀を打とうとしたが、４二にはすでに駒があったので" do
          expect { Player.basic_test2(:init => "４二銀", :exec => "４二銀") }.to raise_error(PieceAlredyExist)
        end
        it "推測結果が複数パターンがあったので" do
          expect { Player.basic_test2(:init => ["６九金", "４九金"], :exec => "５九金") }.to raise_error(AmbiguousFormatError)
        end
        it "ルール上、成っている状態から成らない状態に戻れないので(盤上に飛が見つからないので)" do
          expect { Player.basic_test2(:init => "５五龍", :exec => "５六飛") }.to raise_error(MovableSoldierNotFound)
        end
        it "ルール上、成っている状態から成らない状態に戻れないので(移動元を明記しても同様。ただ例外の種類が異なる)" do
          expect { Player.basic_test2(:init => "５五龍", :exec => "５六飛(55)") }.to raise_error(PromotedPieceToNormalPiece)
        end
      end

      context "成" do
        context "成れる" do
          it "相手陣地に入るときに成る" do
            Player.basic_test2(:init => "２四歩", :exec => "２三歩成").should == ["▲2三と"]
          end
          it "相手陣地から出るときに成る" do
            Player.basic_test2(:init => "５一飛", :exec => "５四飛成").should == ["▲5四龍"]
          end
          it "後手が相手の3段目に入ったタイミングで成る(バグっていたので消さないように)" do
            Player.basic_test2(:player => :white, :init => "４五桂", :exec => "５七桂成").should == ["▽5七圭"]
          end
        end
        context "成れない" do
          it "自分の陣地に入るタイミングでは" do
            expect { Player.basic_test2(:init => "５五飛", :exec => "５九飛成") }.to raise_error(NotPromotable)
          end
          it "自分の陣地から出るタイミングでも" do
            expect { Player.basic_test2(:init => "５九飛", :exec => "５五飛成") }.to raise_error(NotPromotable)
          end
          it "天王山から一歩動いただけじゃ" do
            expect { Player.basic_test2(:init => "５五飛", :exec => "５六飛成") }.to raise_error(NotPromotable)
          end
          it "飛がないので" do
            expect { Player.basic_test2(:init => "５五龍", :exec => "５一飛成") }.to raise_error(MovableSoldierNotFound)
          end
        end
      end

      context "不成" do
        context "できる" do
          it "成を明示しなかったので" do
            Player.basic_test2(:init => "５五桂", :exec => "４三桂").should == ["▲4三桂"]
          end
          it "不成の指定をしたので" do
            Player.basic_test2(:init => "５五桂", :exec => "４三桂不成").should == ["▲4三桂"]
          end
          context "金が不成するケース" do
            it "不成の指定をしたけど金は不成しかないのでまちがっちゃいないけど「金不成」と棋譜が残るのは違和感がある" do
              expect { Player.basic_test(:init => "１四金", :exec => "１三金不成") }.to raise_error(NoPromotablePiece)
            end
            it "不成の指定をしなかった" do
              Player.basic_test(:init => "１四金", :exec => "１三金").parsed_info.last_kif_pair.should== ["1三金(14)", "1三金"]
            end
          end
        end
        context "できない" do
          it "移動できる見込みがないとき" do
            expect { Player.basic_test2(:init => "５三桂", :exec => "４一桂") }.to raise_error(NotPutInPlaceNotBeMoved)
          end
        end
      end

      context "取る" do
        context "取れる" do
          it "座標指定で" do
            frame = LiveFrame.testcase3(:init => [["１五玉", "１四歩"], ["１一玉", "１二歩"]], :exec => ["１三歩成", "１三歩"])
            frame.prev_player.last_piece.name.should == "歩"
            frame.prev_player.to_s_pieces.should == "歩九 角 飛 香二 桂二 銀二 金二"
            frame.prev_player.to_s_soldiers.should == "1一玉 1三歩"
            frame.current_player.to_s_pieces.should == "歩八 角 飛 香二 桂二 銀二 金二"
            frame.current_player.to_s_soldiers.should == "1五玉"
          end
          it "同歩で取る" do
            frame = LiveFrame.testcase3(:init => ["２五歩", "２三歩"], :exec => ["２四歩", "同歩"])
            frame.prev_player.last_piece.name.should == "歩"
            frame.prev_player.to_s_pieces.should == "歩九 角 飛 香二 桂二 銀二 金二 玉"
            frame.prev_player.to_s_soldiers.should == "2四歩"
            frame.current_player.to_s_pieces.should == "歩八 角 飛 香二 桂二 銀二 金二 玉"
            frame.current_player.to_s_soldiers.should == ""
          end
        end
        context "取れない" do
          # 相手がいないと同角は失敗するので「相手がいない」というエラーすることも検討
          it "一人で同を使う(同角で２五がわかった上で移動しようとしたけど自分の飛車がいるために移動できなかった)" do
            expect { Player.basic_test2(:init => ["２五飛", "８八角"], :exec => ["５五飛", "同角"]) }.to raise_error(MovableSoldierNotFound, /5五に移動できる角がありません/)
          end
          it "初手に同歩" do
            expect { Player.basic_test2(:exec => "同歩") }.to raise_error(BeforePointNotFound)
          end
        end
      end
    end

    context "打つ" do
      context "打てる" do
        it "空いているところに" do
          Player.basic_test2(:exec => "５五歩打").should == ["▲5五歩"]
        end

        # 棋譜の表記方法：日本将棋連盟 http://www.shogi.or.jp/faq/kihuhyouki.html
        # > ※「打」と記入するのはあくまでもその地点に盤上の駒を動かすこともできる場合のみです。それ以外の場合は、持駒を打つ場合も「打」はつけません。
        it "打は曖昧なときだけ付く" do
          Player.basic_test2(:exec => "５五歩").should == ["▲5五歩"]
          Player.basic_test(:exec => "５五歩").parsed_info.last_kif.should == "5五歩打"
        end

        it "２二角成としたけど盤上に何もないので持駒の角を打った(打てていたけど、成と書いて打てるのはおかしいのでエラーとする)" do
          expect { Player.basic_test(:exec => ["２二角成"]) }.to raise_error(IllegibleFormat)
        end

        it "盤上に竜があってその横に飛を「打」をつけずに打った(打つときに他の駒もそこに来れそうなケース。実際は竜なので来れない)" do
          Player.basic_test(:deal => "飛", :init => "１一龍", :exec => "２一飛").parsed_info.last_kif.should == "2一飛打"
        end

        it "と金は二歩にならないので" do
          Player.basic_test2(:init => "５五と", :exec => "５六歩打").should == ["▲5五と", "▲5六歩"]
        end
      end

      context "打てない" do
        it "場外に" do
          expect { Player.basic_test2(:exec => "５十飛打") }.to raise_error(PositionSyntaxError)
        end
        it "自分の駒の上に" do
          expect { Player.basic_test2(:init => "５五飛", :exec => "５五角打") }.to raise_error(PieceAlredyExist)
        end
        it "相手の駒の上に" do
          expect { LiveFrame.testcase3(:exec => ["５五飛打", "５五角打"]) }.to raise_error(PieceAlredyExist)
        end
        it "卍という駒がないので" do
          expect { Player.basic_test2(:exec => "５五卍打") }.to raise_error(SyntaxError)
        end
        it "成った状態で" do
          expect { Player.basic_test2(:exec => "５五龍打") }.to raise_error(PromotedPiecePutOnError)
        end
        it "１一歩打だとそれ以上動けないので" do
          expect { Player.basic_test2(:exec => "１一歩打") }.to raise_error(NotPutInPlaceNotBeMoved)
        end
        it "二歩なので" do
          expect { Player.basic_test2(:init => "５五歩", :exec => "５九歩打") }.to raise_error(DoublePawn)
        end
      end
    end

    context "人間が入力する棋譜" do
      before do
        @params = {:deal => "飛 角"}
      end

      context "http://www.shogi.or.jp/faq/kihuhyouki.html" do
        context "龍" do
          it "パターンA" do
            @params.update(:init => ["９一龍", "８四龍"])
            Player.basic_test(@params.merge(:exec => "８二龍引")).parsed_info.last_kif_pair.should == ["8二龍(91)", "8二龍引"]
            Player.basic_test(@params.merge(:exec => "８二龍上")).parsed_info.last_kif_pair.should == ["8二龍(84)", "8二龍上"]
          end
          it "パターンB" do
            @params.update(:init => ["５二龍", "２三龍"])
            Player.basic_test(@params.merge(:exec => "４三龍寄")).parsed_info.last_kif_pair.should == ["4三龍(23)", "4三龍寄"]
            Player.basic_test(@params.merge(:exec => "４三龍引")).parsed_info.last_kif_pair.should == ["4三龍(52)", "4三龍引"]
          end
          it "パターンC" do
            @params.update(:init => ["５五龍", "１五龍"])
            Player.basic_test(@params.merge(:exec => "３五龍左")).parsed_info.last_kif_pair.should == ["3五龍(55)", "3五龍左"]
            Player.basic_test(@params.merge(:exec => "３五龍右")).parsed_info.last_kif_pair.should == ["3五龍(15)", "3五龍右"]
          end
          it "パターンD" do
            @params.update(:init => ["９九龍", "８九龍"])
            Player.basic_test(@params.merge(:exec => "８八龍左")).parsed_info.last_kif_pair.should == ["8八龍(99)", "8八龍左"]
            Player.basic_test(@params.merge(:exec => "８八龍右")).parsed_info.last_kif_pair.should == ["8八龍(89)", "8八龍右"]
          end
          it "パターンE" do
            @params.update(:init => ["２八龍", "１九龍"])
            Player.basic_test(@params.merge(:exec => "１七龍左")).parsed_info.last_kif_pair.should == ["1七龍(28)", "1七龍左"]
            Player.basic_test(@params.merge(:exec => "１七龍右")).parsed_info.last_kif_pair.should == ["1七龍(19)", "1七龍右"]
          end
        end

        context "馬" do
          it "パターンA" do
            @params.update(:init => ["９一馬", "８一馬"])
            Player.basic_test(@params.merge(:exec => "８二馬左")).parsed_info.last_kif_pair.should == ["8二馬(91)", "8二馬左"]
            Player.basic_test(@params.merge(:exec => "８二馬右")).parsed_info.last_kif_pair.should == ["8二馬(81)", "8二馬右"]
          end
          it "パターンB" do
            @params.update(:init => ["９五馬", "６三馬"])
            Player.basic_test(@params.merge(:exec => "８五馬寄")).parsed_info.last_kif_pair.should == ["8五馬(95)", "8五馬寄"]
            Player.basic_test(@params.merge(:exec => "８五馬引")).parsed_info.last_kif_pair.should == ["8五馬(63)", "8五馬引"]
          end
          it "パターンC" do
            @params.update(:init => ["１一馬", "３四馬"])
            Player.basic_test(@params.merge(:exec => "１二馬引")).parsed_info.last_kif_pair.should == ["1二馬(11)", "1二馬引"]
            Player.basic_test(@params.merge(:exec => "１二馬上")).parsed_info.last_kif_pair.should == ["1二馬(34)", "1二馬上"]
          end
          it "パターンD" do
            @params.update(:init => ["９九馬", "５九馬"])
            Player.basic_test(@params.merge(:exec => "７七馬左")).parsed_info.last_kif_pair.should == ["7七馬(99)", "7七馬左"]
            Player.basic_test(@params.merge(:exec => "７七馬右")).parsed_info.last_kif_pair.should == ["7七馬(59)", "7七馬右"]
          end
          it "パターンE" do
            @params.update(:init => ["４七馬", "１八馬"])
            Player.basic_test(@params.merge(:exec => "２九馬左")).parsed_info.last_kif_pair.should == ["2九馬(47)", "2九馬左"]
            Player.basic_test(@params.merge(:exec => "２九馬右")).parsed_info.last_kif_pair.should == ["2九馬(18)", "2九馬右"]
          end
        end
      end

      it "真右だけ" do
        @params.update({:init => [
              "______", "______", "______",
              "______", "______", "４五と",
              "______", "______", "______",
            ]})
        Player.basic_test(@params.merge(:exec => "５五と")).parsed_info.last_kif_pair.should == ["5五と(45)", "5五と"]
      end

      it "右下だけ" do
        @params.update({:init => [
              "______", "______", "______",
              "______", "______", "______",
              "______", "______", "４六と",
            ]})
        Player.basic_test(@params.merge(:exec => "５五と")).parsed_info.last_kif_pair.should == ["5五と(46)", "5五と"]
      end

      it "真下だけ" do
        @params.update({:init => [
              "______", "______", "______",
              "______", "______", "______",
              "______", "５六と", "______",
            ]})
        Player.basic_test(@params.merge(:exec => "５五と")).parsed_info.last_kif_pair.should == ["5五と(56)", "5五と"]
      end

      it "下面" do
        @params.update({:init => [
              "______", "______", "______",
              "______", "______", "______",
              "６六と", "５六と", "４六と",
            ]})
        Player.basic_test(@params.merge(:exec => "５五と右")).parsed_info.last_kif_pair.should == ["5五と(46)", "5五と右"]
        Player.basic_test(@params.merge(:exec => "５五と直")).parsed_info.last_kif_pair.should == ["5五と(56)", "5五と直"]
        Player.basic_test(@params.merge(:exec => "５五と左")).parsed_info.last_kif_pair.should == ["5五と(66)", "5五と左"]
      end

      it "縦に二つ" do
        @params.update({:init => [
              "______", "５四と", "______",
              "______", "______", "______",
              "______", "５六と", "______",
            ]})
        Player.basic_test(@params.merge(:exec => "５五と引")).parsed_info.last_kif_pair.should == ["5五と(54)", "5五と引"]
        Player.basic_test(@params.merge(:exec => "５五と上")).parsed_info.last_kif_pair.should == ["5五と(56)", "5五と上"]
      end

      it "左と左下" do
        @params.update({:init => [
              "______", "______", "______",
              "６五と", "______", "______",
              "６六と", "______", "______",
            ]})
        Player.basic_test(@params.merge(:exec => "５五と寄")).parsed_info.last_kif_pair.should == ["5五と(65)", "5五と寄"]
        Player.basic_test(@params.merge(:exec => "５五と上")).parsed_info.last_kif_pair.should == ["5五と(66)", "5五と上"]
      end

      it "左上と左下" do
        @params.update({:init => [
              "６四銀", "______", "______",
              "______", "______", "______",
              "６六銀", "______", "______",
            ]})
        Player.basic_test(@params.merge(:exec => "５五銀引")).parsed_info.last_kif_pair.should == ["5五銀(64)", "5五銀引"]
        Player.basic_test(@params.merge(:exec => "５五銀上")).parsed_info.last_kif_pair.should == ["5五銀(66)", "5五銀上"]
      end

      it "左右" do
        @params.update({:init => [
              "______", "______", "______",
              "６五と", "______", "４五と",
              "______", "______", "______",
            ]})
        Player.basic_test(@params.merge(:exec => "５五と左")).parsed_info.last_kif_pair.should == ["5五と(65)", "5五と左"]
        Player.basic_test(@params.merge(:exec => "５五と右")).parsed_info.last_kif_pair.should == ["5五と(45)", "5五と右"]
      end

      it "同" do
        LiveFrame.testcase3(:init => ["２五歩", "２三歩"], :exec => ["２四歩", "同歩"]).prev_player.parsed_info.last_kif_pair.should == ["2四歩(23)", "同歩"]
      end

      it "直と不成が重なるとき「不成」と「直」の方が先にくる" do
        Player.basic_test(:init => ["３四銀", "２四銀"], :exec => "２三銀直不成").parsed_info.last_kif_pair.should == ["2三銀(24)", "2三銀直不成"]
      end

      it "２三銀引成できる？" do
        Player.basic_test(:init => ["３二銀", "３四銀"], :exec => "２三銀引成").parsed_info.last_kif_pair.should == ["2三銀成(32)", "2三銀引成"]
      end
    end

    it "指したあと前回の手を確認できる" do
      Player.basic_test(:init => "５五飛", :exec => "５一飛成").parsed_info.last_kif.should == "5一飛成(55)"
      Player.basic_test(:init => "５一龍", :exec => "１一龍").parsed_info.last_kif.should   == "1一龍(51)"
      Player.basic_test(:exec => "５五飛打").parsed_info.last_kif.should                    == "5五飛打"
    end

    it "持駒の確認" do
      Player.basic_test.to_s_pieces.should == "歩九 角 飛 香二 桂二 銀二 金二 玉"
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
      board.to_s.should == <<-EOT.strip_heredoc
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

    context "評価" do
      it "駒を置いてないとき" do
        Player.basic_test.evaluate.should == 22284
      end
      it "駒を置いているとき" do
        Player.basic_test(:piece_plot => true).evaluate.should == 21699
      end
    end

    context "自動的に打つ" do
      it "ランダムに盤上の駒を動かす" do
        player = Player.basic_test(:piece_plot => true)
        player.generate_way.should be_present
      end
      it "全手筋" do
        player = Player.basic_test(:piece_plot => true)
        player._generate_way.all_ways.should == ["9六歩(97)", "8六歩(87)", "7六歩(77)", "6六歩(67)", "5六歩(57)", "4六歩(47)", "3六歩(37)", "2六歩(27)", "1六歩(17)", "3八飛(28)", "4八飛(28)", "5八飛(28)", "6八飛(28)", "7八飛(28)", "1八飛(28)", "9八香(99)", "7八銀(79)", "6八銀(79)", "7八金(69)", "6八金(69)", "5八金(69)", "6八玉(59)", "5八玉(59)", "4八玉(59)", "5八金(49)", "4八金(49)", "3八金(49)", "4八銀(39)", "3八銀(39)", "1八香(19)"]
      end
    end

    context "GenerateWay" do
      before do
        @save_size = Board.size_change([3, 3])
      end

      after do
        if @save_size
          Board.size_change(@save_size)
        end
      end

      it "盤上の駒の全手筋" do
        player = Player.basic_test(:init => ["1二歩", "2三桂"])
        player._generate_way.soldiers_ways.should == ["1一歩成(12)", "3一桂成(23)", "1一桂成(23)"]
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
        Board.size_change([3, 3])
        player = Player.basic_test(:init => "２二歩", :pieces => "歩")
        player._generate_way.pieces_ways.should == ["3二歩打", "1二歩打", "3三歩打", "1三歩打"]
      end
    end

    # context "一時的に置いてみた状態にする(これ不要かも)" do
    #   it "safe_put_on" do
    #     player = Player.basic_test
    #     player.to_s_pieces.should == "歩九 角 飛 香二 桂二 銀二 金二 玉"
    #     player.safe_put_on("5五飛") do
    #       player.to_s_pieces.should == "歩九 角 香二 桂二 銀二 金二 玉"
    #       player.safe_put_on("4五角") do
    #         player.to_s_pieces.should == "歩九 香二 桂二 銀二 金二 玉"
    #       end
    #       player.to_s_pieces.should == "歩九 香二 桂二 銀二 金二 玉 角"
    #     end
    #     player.to_s_pieces.should == "歩九 香二 桂二 銀二 金二 玉 角 飛"
    #   end
    # end

    it "復元するのは持駒と盤上の駒のみ。復元時に盤を指してないことに注意" do
      player1 = Player.basic_test(:init => "５九玉", :exec => "５八玉")
      player1.soldier_names.should == ["▲5八玉"]
      player1.to_s_pieces.should == "歩九 角 飛 香二 桂二 銀二 金二"

      player2 = Marshal.load(Marshal.dump(player1))
      player2.soldier_names.should == ["▲5八玉"]
      player2.to_s_pieces.should == "歩九 角 飛 香二 桂二 銀二 金二"
      player2.board.should == nil
    end
  end
end
