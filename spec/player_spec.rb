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
      player.pieces_compact_str.should == ""
      player.deal("飛 歩二")
      player.pieces_compact_str.should == "飛 歩二"
      player.pieces.clear
      player.deal
      player.pieces_compact_str.should == "歩九 角 飛 香二 桂二 銀二 金二 玉"
    end

    context "配置" do
      context "できる" do
        it "歩を相手の陣地に" do
          Player.soldiers_test(:init => "5三歩").should == ["▲5三歩"]
        end
        it "成っている歩を相手の陣地に" do
          Player.soldiers_test(:init => "5三と").should == ["▲5三と"]
        end
        it "後手が置ける" do
          Player.soldiers_test(:init => "５五飛", :player => :white).should == ["▽5五飛↓"]
        end
      end
      context "できない" do
        it "成っている金を相手の陣地に" do
          expect { Player.soldiers_test(:init => "5三成金").to }.to raise_error(SyntaxError)
        end
        it "すでに駒があるところに駒を配置できない" do
          expect { Player.soldiers_test(:init => ["5三銀", "5三銀"]).to }.to raise_error(PieceAlredyExist)
        end
        it "飛車は二枚持ってないので二枚配置できない" do
          expect { Player.soldiers_test(:init => ["5二飛", "5二飛"]) }.to raise_error(PieceNotFound)
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
          Player.soldiers_test(:init => "７七歩", :exec => "７六歩").should == ["▲7六歩"]
        end
        it "後手の歩を(画面上では下がることに注意)" do
          Player.soldiers_test(:player => :white, :init => "３三歩", :exec => "３四歩").should == ["▽3四歩↓"]
        end
        it "成銀を" do
          Player.soldiers_test(:init => "４二成銀", :exec => "３二成銀").should == ["▲3二全"]
        end
        it "龍を" do
          Player.soldiers_test(:init => "４二龍", :exec => "３二龍").should == ["▲3二龍"]
        end
        it "駒の指定なしで動かす" do
          # 初手 "７六" とした場合、そこに来れるのは真下の、"歩" のみなので "７六歩" とする
          # というのはやりすぎなので保留
        end
        it "推測結果が複数パターンあるけど移動元が明確であれば推測しないのでエラーにならない" do
          Player.soldiers_test(:init => ["６九金", "４九金"], :exec => "５九金(49)").should == ["▲5九金", "▲6九金"]
        end
      end

      context "できない" do
        it "４二に移動できる銀が見つからず、持駒の銀を打とうとしたが、４二にはすでに駒があったので" do
          expect { Player.soldiers_test(:init => "４二銀", :exec => "４二銀") }.to raise_error(PieceAlredyExist)
        end
        it "推測結果が複数パターンがあったので" do
          expect { Player.soldiers_test(:init => ["６九金", "４九金"], :exec => "５九金") }.to raise_error(AmbiguousFormatError)
        end
        it "ルール上、成っている状態から成らない状態に戻れないので(盤上に飛が見つからないので)" do
          expect { Player.soldiers_test(:init => "５五龍", :exec => "５六飛") }.to raise_error(MovableSoldierNotFound)
        end
        it "ルール上、成っている状態から成らない状態に戻れないので(移動元を明記しても同様。ただ例外の種類が異なる)" do
          expect { Player.soldiers_test(:init => "５五龍", :exec => "５六飛(55)") }.to raise_error(PromotedPieceToNormalPiece)
        end
      end

      context "成" do
        context "成れる" do
          it "相手陣地に入るときに成る" do
            Player.soldiers_test(:init => "２四歩", :exec => "２三歩成").should == ["▲2三と"]
          end
          it "相手陣地から出るときに成る" do
            Player.soldiers_test(:init => "５一飛", :exec => "５四飛成").should == ["▲5四龍"]
          end
          it "後手が相手の3段目に入ったタイミングで成る(バグっていたので消さないように)" do
            Player.soldiers_test(:player => :white, :init => "４五桂", :exec => "５七桂成").should == ["▽5七圭↓"]
          end
        end
        context "成れない" do
          it "自分の陣地に入るタイミングでは" do
            expect { Player.soldiers_test(:init => "５五飛", :exec => "５九飛成") }.to raise_error(NotPromotable)
          end
          it "自分の陣地から出るタイミングでも" do
            expect { Player.soldiers_test(:init => "５九飛", :exec => "５五飛成") }.to raise_error(NotPromotable)
          end
          it "天王山から一歩動いただけじゃ" do
            expect { Player.soldiers_test(:init => "５五飛", :exec => "５六飛成") }.to raise_error(NotPromotable)
          end
          it "飛がないので" do
            expect { Player.soldiers_test(:init => "５五龍", :exec => "５一飛成") }.to raise_error(MovableSoldierNotFound)
          end
        end
      end

      context "不成" do
        context "できる" do
          it "成と明示しなかったので" do
            Player.soldiers_test(:init => "５五桂", :exec => "４三桂").should == ["▲4三桂"]
          end
          it "不成の指定をしたので" do
            Player.soldiers_test(:init => "５五桂", :exec => "４三桂不成").should == ["▲4三桂"]
          end
        end
        context "できない" do
          it "移動できる見込みがないとき" do
            expect { Player.soldiers_test(:init => "５三桂", :exec => "４一桂") }.to raise_error(NotPutInPlaceNotBeMoved)
          end
        end
      end

      context "取る" do
        context "取れる" do
          it "座標指定で" do
            frame = LiveFrame.testcase3(:init => ["５六歩", "５五飛"], :exec => ["５五歩"])
            frame.prev_player.last_piece.name.should == "飛"
          end
          it "同歩で取る" do
            frame = LiveFrame.testcase3(:init => ["２五歩", "２三歩"], :exec => ["２四歩", "同歩"])
            frame.prev_player.last_piece.name.should == "歩"
          end
        end
        context "取れない" do
          # 相手がいないと同角は失敗するので「相手がいない」というエラーすることも検討
          it "一人で同を使う(同角で２五がわかった上で移動しようとしたけど自分の飛車がいるために移動できなかった)" do
            expect { Player.soldiers_test(:init => ["２五飛", "８八角"], :exec => ["５五飛", "同角"]) }.to raise_error(MovableSoldierNotFound, /5五に移動できる角がありません/)
          end
          it "初手に同歩" do
            expect { Player.soldiers_test(:exec => "同歩") }.to raise_error(BeforePointNotFound)
          end
        end
      end
    end

    context "打つ" do
      context "打てる" do
        it "空いているところに" do
          Player.soldiers_test(:exec => "５五歩打").should == ["▲5五歩"]
        end

        # 棋譜の表記方法：日本将棋連盟 http://www.shogi.or.jp/faq/kihuhyouki.html
        # > ※「打」と記入するのはあくまでもその地点に盤上の駒を動かすこともできる場合のみです。それ以外の場合は、持駒を打つ場合も「打」はつけません。
        it "打は曖昧なときだけ付く" do
          Player.soldiers_test(:exec => "５五歩").should == ["▲5五歩"]
          Player.basic_test(:exec => "５五歩").parsed_info.last_kif.should == "5五歩打"
        end

        it "盤上に龍があってその横に飛を「打」をつけずに打った(打つときに他の駒もそこに来れるケース)" do
          Player.basic_test(:deal => "飛", :init => "１一龍", :exec => "２一飛").parsed_info.last_kif.should == "2一飛打"
        end

        it "と金は二歩にならないので" do
          Player.soldiers_test(:init => "５五と", :exec => "５六歩打").should == ["▲5五と", "▲5六歩"]
        end
      end

      context "打てない" do
        it "場外に" do
          expect { Player.soldiers_test(:exec => "５十飛打") }.to raise_error(PositionSyntaxError)
        end
        it "自分の駒の上に" do
          expect { Player.soldiers_test(:init => "５五飛", :exec => "５五角打") }.to raise_error(PieceAlredyExist)
        end
        it "相手の駒の上に" do
          expect { LiveFrame.testcase3(:exec => ["５五飛打", "５五角打"]) }.to raise_error(PieceAlredyExist)
        end
        it "卍という駒がないので" do
          expect { Player.soldiers_test(:exec => "５五卍打") }.to raise_error(SyntaxError)
        end
        it "成った状態で" do
          expect { Player.soldiers_test(:exec => "５五龍打") }.to raise_error(PromotedPiecePutOnError)
        end
        it "１一歩打だとそれ以上動けないので" do
          expect { Player.soldiers_test(:exec => "１一歩打") }.to raise_error(NotPutInPlaceNotBeMoved)
        end
        it "二歩なので" do
          expect { Player.soldiers_test(:init => "５五歩", :exec => "５九歩打") }.to raise_error(DoublePawn)
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
      Player.basic_test.pieces_compact_str.should == "歩九 角 飛 香二 桂二 銀二 金二 玉"
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
      it "盤上の駒の全手筋" do
        player = Player.basic_test(:piece_plot => true)
        # player._generate_way.soldiers_ways.should == ["9六歩(97)", "8六歩(87)", "7六歩(77)", "6六歩(67)", "5六歩(57)", "4六歩(47)", "3六歩(37)", "2六歩(27)", "1六歩(17)", "3八飛(28)", "4八飛(28)", "5八飛(28)", "6八飛(28)", "7八飛(28)", "1八飛(28)", "9八香(99)", "7八銀(79)", "6八銀(79)", "7八金(69)", "6八金(69)", "5八金(69)", "6八玉(59)", "5八玉(59)", "4八玉(59)", "5八金(49)", "4八金(49)", "3八金(49)", "4八銀(39)", "3八銀(39)", "1八香(19)"]
      end
      it "持駒の全手筋" do
        player = Player.basic_test
        # player._generate_way.pieces_ways.should == ["9一角打", "9一銀打", "9一金打", "9一玉打", "9一銀打", "9一玉打", "9一銀打", "9一銀打", "8一飛打", "8一金打", "8一金打", "8一玉打", "8一銀打", "8一金打", "8一金打", "8一銀打", "8一金打", "8一金打", "7一飛打", "7一玉打", "7一銀打", "7一金打", "7一玉打", "7一金打", "7一玉打", "7一玉打", "6一角打", "6一銀打", "6一玉打", "6一銀打", "6一玉打", "6一銀打", "6一銀打", "5一飛打", "5一金打", "5一玉打", "5一銀打", "5一金打", "5一銀打", "4一角打", "4一飛打", "4一銀打", "4一銀打", "4一飛打", "4一銀打", "4一銀打", "4一銀打", "3一金打", "3一玉打", "3一角打", "3一銀打", "3一玉打", "3一銀打", "2一金打", "2一銀打", "2一銀打", "2一銀打", "2一銀打", "2一銀打", "1一飛打", "1一角打", "1一銀打", "1一角打", "1一銀打", "9二金打", "9二金打", "9二飛打", "9二銀打", "9二銀打", "9二金打", "9二銀打", "9二銀打", "9二銀打", "8二玉打", "8二香打", "8二金打", "8二銀打", "8二香打", "8二銀打", "7二角打", "7二金打", "7二香打", "7二銀打", "7二銀打", "7二金打", "7二銀打", "7二銀打", "7二銀打", "6二飛打", "6二香打", "6二金打", "6二銀打", "6二香打", "6二銀打", "5二玉打", "5二金打", "5二香打", "5二銀打", "5二銀打", "5二金打", "5二銀打", "5二銀打", "5二銀打", "4二角打", "4二香打", "4二金打", "4二銀打", "4二香打", "4二銀打", "3二飛打", "3二金打", "3二香打", "3二銀打", "3二銀打", "3二金打", "3二銀打", "3二銀打", "3二銀打", "2二玉打", "2二香打", "2二金打", "2二銀打", "2二香打", "2二銀打", "1二角打", "1二金打", "1二香打", "1二銀打", "1二銀打", "1二金打", "1二銀打", "1二銀打", "1二銀打", "9三飛打", "9三香打", "9三金打", "9三桂打", "9三桂打", "9三銀打", "9三香打", "9三桂打", "9三銀打", "9三桂打", "9三桂打", "8三玉打", "8三金打", "8三香打", "8三銀打", "8三銀打", "8三桂打", "8三金打", "8三銀打", "8三桂打", "8三銀打", "8三銀打", "7三角打", "7三香打", "7三金打", "7三桂打", "7三桂打", "7三銀打", "7三香打", "7三桂打", "7三銀打", "7三桂打", "7三桂打", "6三飛打", "6三金打", "6三香打", "6三銀打", "6三銀打", "6三桂打", "6三金打", "6三銀打", "6三桂打", "6三銀打", "6三銀打", "5三玉打", "5三香打", "5三金打", "5三桂打", "5三桂打", "5三銀打", "5三香打", "5三桂打", "5三銀打", "5三桂打", "5三桂打", "4三角打", "4三金打", "4三香打", "4三銀打", "4三銀打", "4三桂打", "4三金打", "4三銀打", "4三桂打", "4三銀打", "4三銀打", "3三飛打", "3三香打", "3三金打", "3三桂打", "3三桂打", "3三銀打", "3三香打", "3三桂打", "3三銀打", "3三桂打", "3三桂打", "2三玉打", "2三金打", "2三香打", "2三銀打", "2三銀打", "2三桂打", "2三金打", "2三銀打", "2三桂打", "2三銀打", "2三銀打", "1三角打", "1三香打", "1三金打", "1三桂打", "1三桂打", "1三銀打", "1三香打", "1三桂打", "1三銀打", "1三桂打", "1三桂打", "9四飛打", "9四金打", "9四香打", "9四銀打", "9四銀打", "9四桂打", "9四金打", "9四銀打", "9四桂打", "9四銀打", "9四銀打", "8四玉打", "8四香打", "8四金打", "8四桂打", "8四桂打", "8四銀打", "8四香打", "8四桂打", "8四銀打", "8四桂打", "8四桂打", "7四角打", "7四金打", "7四香打", "7四銀打", "7四銀打", "7四桂打", "7四金打", "7四銀打", "7四桂打", "7四銀打", "7四銀打", "6四飛打", "6四香打", "6四金打", "6四桂打", "6四桂打", "6四銀打", "6四香打", "6四桂打", "6四銀打", "6四桂打", "6四桂打", "5四玉打", "5四金打", "5四香打", "5四銀打", "5四銀打", "5四桂打", "5四金打", "5四銀打", "5四桂打", "5四銀打", "5四銀打", "4四角打", "4四香打", "4四金打", "4四桂打", "4四桂打", "4四銀打", "4四香打", "4四桂打", "4四銀打", "4四桂打", "4四桂打", "3四飛打", "3四金打", "3四香打", "3四銀打", "3四銀打", "3四桂打", "3四金打", "3四銀打", "3四桂打", "3四銀打", "3四銀打", "2四玉打", "2四香打", "2四金打", "2四桂打", "2四桂打", "2四銀打", "2四香打", "2四桂打", "2四銀打", "2四桂打", "2四桂打", "1四角打", "1四金打", "1四香打", "1四銀打", "1四銀打", "1四桂打", "1四金打", "1四銀打", "1四桂打", "1四銀打", "1四銀打", "9五飛打", "9五香打", "9五金打", "9五桂打", "9五桂打", "9五銀打", "9五香打", "9五桂打", "9五銀打", "9五桂打", "9五桂打", "8五玉打", "8五金打", "8五香打", "8五銀打", "8五銀打", "8五桂打", "8五金打", "8五銀打", "8五桂打", "8五銀打", "8五銀打", "7五角打", "7五香打", "7五金打", "7五桂打", "7五桂打", "7五銀打", "7五香打", "7五桂打", "7五銀打", "7五桂打", "7五桂打", "6五飛打", "6五金打", "6五香打", "6五銀打", "6五銀打", "6五桂打", "6五金打", "6五銀打", "6五桂打", "6五銀打", "6五銀打", "5五玉打", "5五香打", "5五金打", "5五桂打", "5五桂打", "5五銀打", "5五香打", "5五桂打", "5五銀打", "5五桂打", "5五桂打", "4五角打", "4五金打", "4五香打", "4五銀打", "4五銀打", "4五桂打", "4五金打", "4五銀打", "4五桂打", "4五銀打", "4五銀打", "3五飛打", "3五香打", "3五金打", "3五桂打", "3五桂打", "3五銀打", "3五香打", "3五桂打", "3五銀打", "3五桂打", "3五桂打", "2五玉打", "2五金打", "2五香打", "2五銀打", "2五銀打", "2五桂打", "2五金打", "2五銀打", "2五桂打", "2五銀打", "2五銀打", "1五角打", "1五香打", "1五金打", "1五桂打", "1五桂打", "1五銀打", "1五香打", "1五桂打", "1五銀打", "1五桂打", "1五桂打", "9六飛打", "9六金打", "9六香打", "9六銀打", "9六銀打", "9六桂打", "9六金打", "9六銀打", "9六桂打", "9六銀打", "9六銀打", "8六玉打", "8六香打", "8六金打", "8六桂打", "8六桂打", "8六銀打", "8六香打", "8六桂打", "8六銀打", "8六桂打", "8六桂打", "7六角打", "7六金打", "7六香打", "7六銀打", "7六銀打", "7六桂打", "7六金打", "7六銀打", "7六桂打", "7六銀打", "7六銀打", "6六飛打", "6六香打", "6六金打", "6六桂打", "6六桂打", "6六銀打", "6六香打", "6六桂打", "6六銀打", "6六桂打", "6六桂打", "5六玉打", "5六金打", "5六香打", "5六銀打", "5六銀打", "5六桂打", "5六金打", "5六銀打", "5六桂打", "5六銀打", "5六銀打", "4六角打", "4六香打", "4六金打", "4六桂打", "4六桂打", "4六銀打", "4六香打", "4六桂打", "4六銀打", "4六桂打", "4六桂打", "3六飛打", "3六金打", "3六香打", "3六銀打", "3六銀打", "3六桂打", "3六金打", "3六銀打", "3六桂打", "3六銀打", "3六銀打", "2六玉打", "2六香打", "2六金打", "2六桂打", "2六桂打", "2六銀打", "2六香打", "2六桂打", "2六銀打", "2六桂打", "2六桂打", "1六角打", "1六金打", "1六香打", "1六銀打", "1六銀打", "1六桂打", "1六金打", "1六銀打", "1六桂打", "1六銀打", "1六銀打", "9七飛打", "9七香打", "9七金打", "9七桂打", "9七桂打", "9七銀打", "9七香打", "9七桂打", "9七銀打", "9七桂打", "9七桂打", "8七玉打", "8七金打", "8七香打", "8七銀打", "8七銀打", "8七桂打", "8七金打", "8七銀打", "8七桂打", "8七銀打", "8七銀打", "7七角打", "7七香打", "7七金打", "7七桂打", "7七桂打", "7七銀打", "7七香打", "7七桂打", "7七銀打", "7七桂打", "7七桂打", "6七飛打", "6七金打", "6七香打", "6七銀打", "6七銀打", "6七桂打", "6七金打", "6七銀打", "6七桂打", "6七銀打", "6七銀打", "5七玉打", "5七香打", "5七金打", "5七桂打", "5七桂打", "5七銀打", "5七香打", "5七桂打", "5七銀打", "5七桂打", "5七桂打", "4七角打", "4七金打", "4七香打", "4七銀打", "4七銀打", "4七桂打", "4七金打", "4七銀打", "4七桂打", "4七銀打", "4七銀打", "3七飛打", "3七香打", "3七金打", "3七桂打", "3七桂打", "3七銀打", "3七香打", "3七桂打", "3七銀打", "3七桂打", "3七桂打", "2七玉打", "2七金打", "2七香打", "2七銀打", "2七銀打", "2七桂打", "2七金打", "2七銀打", "2七桂打", "2七銀打", "2七銀打", "1七角打", "1七香打", "1七金打", "1七桂打", "1七桂打", "1七銀打", "1七香打", "1七桂打", "1七銀打", "1七桂打", "1七桂打", "9八飛打", "9八金打", "9八香打", "9八銀打", "9八銀打", "9八桂打", "9八金打", "9八銀打", "9八桂打", "9八銀打", "9八銀打", "8八玉打", "8八香打", "8八金打", "8八桂打", "8八桂打", "8八銀打", "8八香打", "8八桂打", "8八銀打", "8八桂打", "8八桂打", "7八角打", "7八金打", "7八香打", "7八銀打", "7八銀打", "7八桂打", "7八金打", "7八銀打", "7八桂打", "7八銀打", "7八銀打", "6八飛打", "6八香打", "6八金打", "6八桂打", "6八桂打", "6八銀打", "6八香打", "6八桂打", "6八銀打", "6八桂打", "6八桂打", "5八玉打", "5八金打", "5八香打", "5八銀打", "5八銀打", "5八桂打", "5八金打", "5八銀打", "5八桂打", "5八銀打", "5八銀打", "4八角打", "4八香打", "4八金打", "4八桂打", "4八桂打", "4八銀打", "4八香打", "4八桂打", "4八銀打", "4八桂打", "4八桂打", "3八飛打", "3八金打", "3八香打", "3八銀打", "3八銀打", "3八桂打", "3八金打", "3八銀打", "3八桂打", "3八銀打", "3八銀打", "2八玉打", "2八香打", "2八金打", "2八桂打", "2八桂打", "2八銀打", "2八香打", "2八桂打", "2八銀打", "2八桂打", "2八桂打", "1八角打", "1八金打", "1八香打", "1八銀打", "1八銀打", "1八桂打", "1八金打", "1八銀打", "1八桂打", "1八銀打", "1八銀打", "9九飛打", "9九香打", "9九金打", "9九桂打", "9九桂打", "9九銀打", "9九香打", "9九桂打", "9九銀打", "9九桂打", "9九桂打", "8九玉打", "8九金打", "8九香打", "8九銀打", "8九銀打", "8九桂打", "8九金打", "8九銀打", "8九桂打", "8九銀打", "8九銀打", "7九角打", "7九香打", "7九金打", "7九桂打", "7九桂打", "7九銀打", "7九香打", "7九桂打", "7九銀打", "7九桂打", "7九桂打", "6九飛打", "6九金打", "6九香打", "6九銀打", "6九銀打", "6九桂打", "6九金打", "6九銀打", "6九桂打", "6九銀打", "6九銀打", "5九玉打", "5九香打", "5九金打", "5九桂打", "5九桂打", "5九銀打", "5九香打", "5九桂打", "5九銀打", "5九桂打", "5九桂打", "4九角打", "4九金打", "4九香打", "4九銀打", "4九銀打", "4九桂打", "4九金打", "4九銀打", "4九桂打", "4九銀打", "4九銀打", "3九飛打", "3九香打", "3九金打", "3九桂打", "3九桂打", "3九銀打", "3九香打", "3九桂打", "3九銀打", "3九桂打", "3九桂打", "2九玉打", "2九金打", "2九香打", "2九銀打", "2九銀打", "2九桂打", "2九金打", "2九銀打", "2九桂打", "2九銀打", "2九銀打", "1九角打", "1九香打", "1九金打", "1九桂打", "1九桂打", "1九銀打", "1九香打", "1九桂打", "1九銀打", "1九桂打", "1九桂打"]
      end
    end

    context "一時的に置いてみた状態にする" do
      it "safe_put_on" do
        player = Player.basic_test
        player.pieces_compact_str.should == "歩九 角 飛 香二 桂二 銀二 金二 玉"
        player.safe_put_on("5五飛") do
          player.pieces_compact_str.should == "歩九 角 香二 桂二 銀二 金二 玉"
          player.safe_put_on("4五角") do
            player.pieces_compact_str.should == "歩九 香二 桂二 銀二 金二 玉"
          end
          player.pieces_compact_str.should == "歩九 香二 桂二 銀二 金二 玉 角"
        end
        player.pieces_compact_str.should == "歩九 香二 桂二 銀二 金二 玉 角 飛"
      end
    end
  end
end
