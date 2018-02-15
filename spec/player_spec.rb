require_relative "spec_helper"

module Warabi
  describe Player do
    it "座標を漢字・全角数字・半角数字のみでも指定できる" do
      Mediator.player_test_soldier_names(init: "五五歩", exec: "五四歩").should == ["▲５四歩"]
      Mediator.player_test_soldier_names(init: "55歩", exec: "54歩").should == ["▲５四歩"]
      Mediator.player_test_soldier_names(init: "５５歩", exec: "５４歩").should == ["▲５四歩"]
    end

    it "移動元明示" do
      Mediator.player_test_soldier_names(init: "５五歩", exec: "５四歩(55)").should == ["▲５四歩"]
    end

    it "持駒がある？" do
      Mediator.player_test.piece_box.exist?(Piece["歩"]).should == true
    end

    describe "駒を配る" do
      it "平手のデフォルト" do
        Mediator.player_test.piece_box.to_s.should == "玉 飛 角 金二 銀二 桂二 香二 歩九"
      end
      it "任意" do
        Mediator.player_test(initial_deal: false, pieces_add: "飛 歩二").piece_box.to_s.should == "飛 歩二"
      end
    end

    describe "配置" do
      describe "できる" do
        it "歩を相手の陣地に" do
          Mediator.player_test_soldier_names(init: "５三歩").should == ["▲５三歩"]
        end
        it "成っている歩を相手の陣地に" do
          Mediator.player_test_soldier_names(init: "５三と").should == ["▲５三と"]
        end
        it "後手が置ける" do
          Mediator.player_test_soldier_names(init: "５五飛", player: :white).should == ["△５五飛"]
        end
      end

      describe "できない" do
        it "成っている金を相手の陣地に" do
          expect { Mediator.player_test_soldier_names(init: "５三成金") }.to raise_error(SyntaxDefact)
        end
        it "すでに駒があるところに駒を配置できない" do
          expect { Mediator.player_test_soldier_names(init: ["５三銀", "５三銀"]) }.to raise_error(PieceAlredyExist)
        end
        it "飛車は二枚持ってないので二枚配置できない" do
          expect { Mediator.player_test_soldier_names(init: ["５二飛", "５二飛"]) }.to raise_error(HoldPieceNotFound)
        end
      end
    end

    it "初期配置" do
      mediator = Mediator.start
      mediator.board.to_s.should == <<~EOT
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
          Mediator.player_test_soldier_names(init: "７七歩", exec: "７六歩").should == ["▲７六歩"]
        end

        it "後手の歩を(画面上では下がることに注意)" do
          Mediator.player_test_soldier_names(player: :white, init: "３三歩", exec: "３四歩").should == ["△３四歩"]
        end

        it "成銀を" do
          Mediator.player_test_soldier_names(init: "４二成銀", exec: "３二成銀").should == ["▲３二全"]
        end

        it "龍を" do
          Mediator.player_test_soldier_names(init: "４二龍", exec: "３二龍").should == ["▲３二龍"]
        end

        it "推測結果が複数パターンあるけど移動元が明確であれば推測しないのでエラーにならない" do
          Mediator.player_test_soldier_names(init: ["６九金", "４九金"], exec: "５九金(49)").should == ["▲５九金", "▲６九金"]
        end

        describe "「と」と「歩」が縦列にある状態でどちらを進めても二歩にならない" do
          it "とを進める" do
            Mediator.player_test_soldier_names(init: ["１二と", "１四歩"], exec: "１三歩").should == ["▲１三歩", "▲１二と"]
          end

          it "歩を進める" do
            Mediator.player_test_soldier_names(init: ["１二と", "１四歩"], exec: "１一と").should == ["▲１一と", "▲１四歩"]
          end
        end
      end

      describe "できない" do
        it "４二に移動できる銀が見つからず、持駒の銀を打とうとしたが、４二にはすでに駒があったので" do
          expect { Mediator.player_test_soldier_names(init: "４二銀", exec: "４二銀") }.to raise_error(PieceAlredyExist)
        end

        it "推測結果が複数パターンがあったので" do
          expect { Mediator.player_test_soldier_names(init: ["６九金", "４九金"], exec: "５九金") }.to raise_error(AmbiguousFormatError)
        end

        it "ルール上、成っている状態から成らない状態に戻れないので(盤上に飛が見つからないので)" do
          expect { Mediator.player_test_soldier_names(init: "５五龍", exec: "５六飛") }.to raise_error(MovableBattlerNotFound)
        end

        it "ルール上、成っている状態から成らない状態に戻れないので(移動元を明記しても同様。ただ例外の種類が異なる)" do
          expect { Mediator.player_test_soldier_names(init: "５五龍", exec: "５六飛(55)") }.to raise_error(PromotedPieceToNormalPiece)
        end
      end

      describe "成" do
        describe "成れる" do
          it "相手陣地に入るときに成る" do
            Mediator.player_test_soldier_names(init: "２四歩", exec: "２三歩成").should == ["▲２三と"]
          end

          it "相手陣地から出るときに成る" do
            Mediator.player_test_soldier_names(init: "５一飛", exec: "５四飛成").should == ["▲５四龍"]
          end

          it "後手が相手の3段目に入ったタイミングで成る(バグっていたので消さないように)" do
            Mediator.player_test_soldier_names(player: :white, init: "４五桂", exec: "５七桂成").should == ["△５七圭"]
          end
        end
        describe "成れない" do
          it "自分の陣地に入るタイミングでは" do
            expect { Mediator.player_test_soldier_names(init: "５五飛", exec: "５九飛成") }.to raise_error(NotPromotable)
          end

          it "自分の陣地から出るタイミングでも" do
            expect { Mediator.player_test_soldier_names(init: "５九飛", exec: "５五飛成") }.to raise_error(NotPromotable)
          end

          it "天王山から一歩動いただけじゃ" do
            expect { Mediator.player_test_soldier_names(init: "５五飛", exec: "５六飛成") }.to raise_error(NotPromotable)
          end

          it "飛がないので" do
            expect { Mediator.player_test_soldier_names(init: "５五龍", exec: "５一飛成") }.to raise_error(MovableBattlerNotFound)
          end
        end
      end

      describe "不成" do
        describe "できる" do
          it "成を明示しなかったので" do
            Mediator.player_test_soldier_names(init: "５五桂", exec: "４三桂").should == ["▲４三桂"]
          end

          it "不成の指定をしたので" do
            Mediator.player_test_soldier_names(init: "５五桂", exec: "４三桂不成").should == ["▲４三桂"]
          end

          it "不成の指定をしたので (不成は生とも書ける)" do
            Mediator.player_test_soldier_names(init: "５五桂", exec: "４三桂生").should == ["▲４三桂"]
          end

          describe "金が不成するケース" do
            it "不成の指定をしたけど金は不成しかないのでまちがっちゃいないけど「金不成」と棋譜が残るのは違和感がある" do
              expect { Mediator.player_test(init: "１四金", exec: "１三金不成") }.to raise_error(NoPromotablePiece)
              expect { Mediator.player_test(init: "１四金", exec: "１三金生")   }.to raise_error(NoPromotablePiece)
            end

            it "不成の指定をしなかった" do
              Mediator.player_test(init: "１四金", exec: "１三金").mediator.hand_logs.last.to_kif_ki2.should == ["１三金(14)", "１三金"]
            end
          end
        end
        describe "できない" do
          it "移動できる見込みがないとき" do
            expect { Mediator.player_test_soldier_names(init: "５三桂", exec: "４一桂") }.to raise_error(DeadPieceRuleError)
          end
        end
      end

      describe "取る" do
        describe "取れる" do
          it "座標指定で" do
            mediator = Mediator.test1(init: "▲１五玉 ▲１四歩 △１一玉 △１二歩", exec: ["１三歩成", "１三歩"])
            mediator.flip_player.last_captured_piece.name.should == "歩"
            mediator.flip_player.piece_box.to_s.should == "歩"
            mediator.flip_player.to_s_soldiers.should == "１一玉 １三歩"
            mediator.current_player.piece_box.to_s.should == ""
            mediator.current_player.to_s_soldiers.should == "１五玉"
          end

          it "同歩で取る" do
            mediator = Mediator.test1(init: "▲２五歩 △２三歩", exec: ["２四歩", "同歩"])
            mediator.hand_logs.last.to_kif_ki2.should == ["２四歩(23)", "同歩"]

            mediator.flip_player.last_captured_piece.name.should == "歩"
            mediator.flip_player.piece_box.to_s.should == "歩"
            mediator.flip_player.to_s_soldiers.should == "２四歩"
            mediator.current_player.piece_box.to_s.should == ""
            mediator.current_player.to_s_soldiers.should == ""
          end

          it "「同歩」ではなくわかりやすく「２四同歩」とした場合" do
            mediator = Mediator.test1(init: "▲２五歩 △２三歩", exec: ["２四歩", "２四同歩"])
            mediator.hand_logs.last.to_kif_ki2.should == ["２四歩(23)", "同歩"]
          end

          it "２五の地点にたたみ掛けるときki2形式で同が連続すること" do
            mediator = Mediator.test1(init: "▲２七歩 ▲２八飛 △２三歩 △２二飛", exec: ["２六歩", "２四歩", "２五歩", "同歩", "同飛", "同飛"])
            mediator.ki2_hand_logs.should == ["▲２六歩", "△２四歩", "▲２五歩", "△同歩", "▲同飛", "△同飛"]
          end
        end

        describe "取れない" do
          it "初手に同歩" do
            expect { Mediator.test1(exec: "同歩") }.to raise_error(BeforePointNotFound, /同に対する座標が不明/)
          end
        end
      end
    end

    describe "打つ" do
      describe "打てる" do
        it "空いているところに" do
          Mediator.player_test_soldier_names(exec: "５五歩打").should == ["▲５五歩"]
          Mediator.player_test_soldier_names(exec: "５五歩合").should == ["▲５五歩"]
        end

        # 棋譜の表記方法：日本将棋連盟 http://www.shogi.or.jp/faq/kihuhyouki.html
        # > ※「打」と記入するのはあくまでもその地点に盤上の駒を動かすこともできる場合のみです。それ以外の場合は、持駒を打つ場合も「打」はつけません。
        it "打は曖昧なときだけ付く (このテストはログの変換のテストで入力のテストにはなっていない)" do
          Mediator.player_test_soldier_names(exec: "５五歩").should == ["▲５五歩"]
          Mediator.player_test(exec: "５五歩").mediator.hand_logs.last.to_kif.should == "５五歩打"
        end

        it "２二角成としたけど盤上に何もないので持駒の角を打った(打てていたけど、成と書いて打てるのはおかしいのでエラーとする)" do
          expect { Mediator.player_test(exec: ["２二角成"]) }.to raise_error(IllegibleFormat)
        end

        it "盤上に竜があってその横に飛を「打」をつけずに打った(打つときに他の駒もそこに来れそうなケース。実際は竜なので来れない)" do
          Mediator.player_test(pieces_add: "飛", init: "１一龍", exec: "２一飛").mediator.hand_logs.last.to_kif.should == "２一飛打"
        end

        it "と金は二歩にならないので" do
          Mediator.player_test_soldier_names(init: "５五と", exec: "５六歩打").should == ["▲５五と", "▲５六歩"]
        end
      end

      describe "打てない" do
        it "場外に" do
          expect { Mediator.player_test_soldier_names(exec: "５十飛打") }.to raise_error(SyntaxDefact)
        end

        it "自分の駒の上に" do
          expect { Mediator.player_test_soldier_names(init: "５五飛", exec: "５五角打") }.to raise_error(PieceAlredyExist)
        end

        it "相手の駒の上に" do
          expect { Mediator.test1(exec: ["５五飛打", "５五角打"], pieces_set: "▼飛△角") }.to raise_error(PieceAlredyExist)
        end

        it "卍という駒がないので" do
          expect { Mediator.player_test_soldier_names(exec: "５五卍打") }.to raise_error(SyntaxDefact)
        end

        it "成った状態で" do
          expect { Mediator.player_test_soldier_names(exec: "５五龍打") }.to raise_error(PromotedPiecePutOnError)
        end

        it "１一歩打だとそれ以上動けないので" do
          expect { Mediator.player_test_soldier_names(exec: "１一歩打") }.to raise_error(DeadPieceRuleError)
        end

        it "二歩なので" do
          expect { Mediator.player_test_soldier_names(init: "５五歩", exec: "５九歩打") }.to raise_error(DoublePawnCommonError)
        end
      end

      describe "打の意味が重要なケース" do
        it "打を明示していないので駒を動かした" do
          Mediator.player_test(pieces_add: "飛", init: "１一飛", exec: "１二飛").mediator.hand_logs.last.to_kif_ki2_csa.should == ["１二飛(11)", "１二飛不成", "+1112HI"]
        end
        it "打を明示したので駒を打つ" do
          Mediator.player_test(pieces_add: "飛", init: "１一飛", exec: "１二飛打").mediator.hand_logs.last.to_kif_ki2_csa.should == ["１二飛打", "１二飛打", "+0012HI"]
          Mediator.player_test(pieces_add: "飛", init: "１一飛", exec: "１二飛合").mediator.hand_logs.last.to_kif_ki2_csa.should == ["１二飛打", "１二飛打", "+0012HI"]
        end
      end
    end

    it "指したあと前回の手を確認できる" do
      Mediator.player_test(init: "５五飛", exec: "５一飛成").mediator.hand_logs.last.to_kif.should == "５一飛成(55)"
      Mediator.player_test(init: "５一龍", exec: "１一龍").mediator.hand_logs.last.to_kif.should   == "１一龍(51)"
      Mediator.player_test(exec: "５五飛打").mediator.hand_logs.last.to_kif.should                 == "５五飛打"
    end

    it "持駒の確認" do
      Mediator.player_test.piece_box.to_s.should == "玉 飛 角 金二 銀二 桂二 香二 歩九"
    end

    it "全体確認" do
      mediator = Mediator.new
      mediator.board.set_from_preset_key
      mediator.execute("７六歩")
      mediator.execute("３四歩")
      mediator.execute("２二角成")
      mediator.player_at(:black).piece_box.to_s.should == "角"
      mediator.board.to_s.should == <<~EOT
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

    it "同" do
      Mediator.test1(init: "▲２五歩 △２三歩", exec: ["２四歩", "同歩"]).hand_logs.last.to_kif_ki2.should == ["２四歩(23)", "同歩"]
    end

    it "「５八金(49)」を入力した結果からKI2変換したとき「58金右」となる" do
      # これはいままで ki2 入力でしか試していなかったため不具合を発見できなかった
      # 移動元が明確な kif で入力し、ki2 変換してみると candidate が nil だったので「右」がつかなかった
      # 将棋DB2にも同様の不具合がある
      mediator = Mediator.start
      mediator.execute("５八金(49)")
      mediator.hand_logs.first.to_ki2.should == "５八金右"
    end
  end
end
