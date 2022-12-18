require "spec_helper"

module Bioshogi
  describe Player do
    it "座標を漢字・全角数字・半角数字のみでも指定できる" do
      assert { Container::Basic.player_test_soldier_names(init: "五五歩", execute: "五四歩") == ["▲５四歩"] }
      assert { Container::Basic.player_test_soldier_names(init: "55歩", execute: "54歩") == ["▲５四歩"] }
      assert { Container::Basic.player_test_soldier_names(init: "５５歩", execute: "５４歩") == ["▲５四歩"] }
    end

    it "移動元明示" do
      assert { Container::Basic.player_test_soldier_names(init: "５五歩", execute: "５四歩(55)") == ["▲５四歩"] }
    end

    it "持駒がある？" do
      assert { Container::Basic.player_test.piece_box.exist?(Piece["歩"]) == true }
    end

    describe "駒を配る" do
      it "平手のデフォルト" do
        assert { Container::Basic.player_test.piece_box.to_s == "玉 飛 角 金二 銀二 桂二 香二 歩九" }
      end
      it "任意" do
        assert { Container::Basic.player_test(initial_deal: false, pieces_add: "飛 歩二").piece_box.to_s == "飛 歩二" }
      end
    end

    describe "配置" do
      describe "できる" do
        it "歩を相手の陣地に" do
          assert { Container::Basic.player_test_soldier_names(init: "５三歩") == ["▲５三歩"] }
        end
        it "成っている歩を相手の陣地に" do
          assert { Container::Basic.player_test_soldier_names(init: "５三と") == ["▲５三と"] }
        end
        it "後手が置ける" do
          assert { Container::Basic.player_test_soldier_names(init: "５五飛", player: :white) == ["△５五飛"] }
        end
      end

      describe "できない" do
        it "成っている金を相手の陣地に" do
          expect { Container::Basic.player_test_soldier_names(init: "５三成金") }.to raise_error(SyntaxDefact)
        end
        it "すでに駒があるところに駒を配置できない" do
          expect { Container::Basic.player_test_soldier_names(init: ["５三銀", "５三銀"]) }.to raise_error(PieceAlredyExist)
        end
        it "飛車は二枚持ってないので二枚配置できない" do
          expect { Container::Basic.player_test_soldier_names(init: ["５二飛", "５二飛"]) }.to raise_error(HoldPieceNotFound)
        end
      end
    end

    it "初期配置" do
      container = Container::Basic.start
      expect(container.board.to_s).to eq(<<~EOT)
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
          assert { Container::Basic.player_test_soldier_names(init: "７七歩", execute: "７六歩") == ["▲７六歩"] }
        end

        it "後手の歩を(画面上では下がることに注意)" do
          assert { Container::Basic.player_test_soldier_names(player: :white, init: "３三歩", execute: "３四歩") == ["△３四歩"] }
        end

        it "成銀を" do
          assert { Container::Basic.player_test_soldier_names(init: "４二成銀", execute: "３二成銀") == ["▲３二全"] }
        end

        it "龍を" do
          assert { Container::Basic.player_test_soldier_names(init: "４二龍", execute: "３二龍") == ["▲３二龍"] }
        end

        it "「11飛成」が正しいのにすでに成って「11龍」をしてしまった場合" do
          expect { Container::Basic.player_test_soldier_names(init: "21飛", execute: "11龍") }.to raise_error(Bioshogi::MovableBattlerNotFound)
        end

        it "推測結果が複数パターンあるけど移動元が明確であれば推測しないのでエラーにならない" do
          assert { Container::Basic.player_test_soldier_names(init: ["６九金", "４九金"], execute: "５九金(49)") == ["▲５九金", "▲６九金"] }
        end

        describe "「と」と「歩」が縦列にある状態でどちらを進めても二歩にならない" do
          it "とを進める" do
            assert { Container::Basic.player_test_soldier_names(init: ["１二と", "１四歩"], execute: "１三歩") == ["▲１三歩", "▲１二と"] }
          end

          it "歩を進める" do
            assert { Container::Basic.player_test_soldier_names(init: ["１二と", "１四歩"], execute: "１一と") == ["▲１一と", "▲１四歩"] }
          end
        end

        it "相手の駒を動かそうとした" do
          expect { Container::Basic.start.execute("34歩(33)") }.to raise_error(Bioshogi::ReversePlayerPieceMoveError, /【反則】相手の駒を動かそうとしています。手番違いかもしれません。1手目は☗の手番ですが☖が着手しました/)
        end
      end

      describe "できない" do
        it "４二に移動できる銀が見つからず、持駒の銀を打とうとしたが、４二にはすでに駒があったので" do
          expect { Container::Basic.player_test_soldier_names(init: "４二銀", execute: "４二銀") }.to raise_error(PieceAlredyExist)
        end

        it "推測結果が複数パターンがあったので" do
          expect { Container::Basic.player_test_soldier_names(init: ["６九金", "４九金"], execute: "５八金") }.to raise_error(AmbiguousFormatError, /５八に移動できる駒が2つありますが表記が曖昧なため特定できません。移動元は「６九の金」か「４九の金」のどっちでしょう？/)
          expect { Container::Basic.player_test_soldier_names(init: ["６九金", "４九金"], execute: "５八金上") }.to raise_error(AmbiguousFormatError, /５八に移動できる駒が2つありますが「上」からは特定できません。移動元は「６九の金」か「４九の金」のどっちでしょう？/)
        end

        it "ルール上、成っている状態から成らない状態に戻れないので(盤上に飛が見つからないので打とみなすが飛を持っていない)" do
          expect { Container::Basic.player_test_soldier_names(init: "５五龍", execute: "５六飛") }.to raise_error(HoldPieceNotFound2)
        end

        it "ルール上、成っている状態から成らない状態に戻れないので(移動元を明記しても同様。ただ例外の種類が異なる)" do
          expect { Container::Basic.player_test_soldier_names(init: "５五龍", execute: "５六飛(55)") }.to raise_error(PromotedPieceToNormalPiece)
        end

        it "初手 25歩(27) とした場合、27から1升飛んで25の地点には移動できないので" do
          expect { Container::Basic.player_test_soldier_names(init: "27歩", execute: "25歩(27)") }.to raise_error(SoldierWarpError)
          expect { Container::Basic.player_test_soldier_names(init: "27歩", execute: "2g2e") }.to raise_error(SoldierWarpError)
        end
      end

      describe "成" do
        describe "成れる" do
          it "相手陣地に入るときに成る" do
            assert { Container::Basic.player_test_soldier_names(init: "２四歩", execute: "２三歩成") == ["▲２三と"] }
          end

          it "相手陣地から出るときに成る" do
            assert { Container::Basic.player_test_soldier_names(init: "５一飛", execute: "５四飛成") == ["▲５四龍"] }
          end

          it "後手が相手の3段目に入ったタイミングで成る(バグっていたので消さないように)" do
            assert { Container::Basic.player_test_soldier_names(player: :white, init: "４五桂", execute: "５七桂成") == ["△５七圭"] }
          end
        end
        describe "成れない" do
          it "自分の陣地に入るタイミングでは" do
            expect { Container::Basic.player_test_soldier_names(init: "５五飛", execute: "５九飛成") }.to raise_error(NotPromotable)
          end

          it "自分の陣地から出るタイミングでも" do
            expect { Container::Basic.player_test_soldier_names(init: "５九飛", execute: "５五飛成") }.to raise_error(NotPromotable)
          end

          it "天王山から一歩動いただけじゃ" do
            expect { Container::Basic.player_test_soldier_names(init: "５五飛", execute: "５六飛成") }.to raise_error(NotPromotable)
          end

          it "飛がないので" do
            expect { Container::Basic.player_test_soldier_names(init: "５五龍", execute: "５一飛成") }.to raise_error(MovableBattlerNotFound)
          end
        end
      end

      describe "不成" do
        describe "できる" do
          it "成を明示しなかったので" do
            assert { Container::Basic.player_test_soldier_names(init: "５五桂", execute: "４三桂") == ["▲４三桂"] }
          end

          it "不成の指定をしたので" do
            assert { Container::Basic.player_test_soldier_names(init: "５五桂", execute: "４三桂不成") == ["▲４三桂"] }
          end

          it "不成の指定をしたので (不成は生とも書ける)" do
            assert { Container::Basic.player_test_soldier_names(init: "５五桂", execute: "４三桂生") == ["▲４三桂"] }
          end

          describe "金が不成するケース" do
            it "不成の指定をしたけど金は不成しかないのでまちがっちゃいないけど「金不成」と棋譜が残るのは違和感がある" do
              expect { Container::Basic.player_test(init: "１四金", execute: "１三金不成") }.to raise_error(NoPromotablePiece)
              expect { Container::Basic.player_test(init: "１四金", execute: "１三金生")   }.to raise_error(NoPromotablePiece)
            end

            it "不成の指定をしなかった" do
              assert { Container::Basic.player_test(init: "１四金", execute: "１三金").container.hand_logs.last.to_kif_ki2 == ["１三金(14)", "１三金"] }
            end
          end
        end
        describe "できない" do
          it "移動できる見込みがないとき" do
            expect { Container::Basic.player_test_soldier_names(init: "５三桂", execute: "４一桂") }.to raise_error(DeadPieceRuleError)
          end
        end
      end

      describe "取る" do
        describe "取れる" do
          it "座標指定で" do
            container = Container::Basic.facade(init: "▲１五玉 ▲１四歩 △１一玉 △１二歩", execute: ["１三歩成", "１三歩"])
            assert { container.opponent_player.executor.captured_soldier.piece.name == "歩" }
            assert { container.opponent_player.piece_box.to_s == "歩" }
            assert { container.opponent_player.to_s_soldiers == "１一玉 １三歩" }
            assert { container.current_player.piece_box.to_s == "" }
            assert { container.current_player.to_s_soldiers == "１五玉" }
          end

          it "同歩で取る" do
            container = Container::Basic.facade(init: "▲２五歩 △２三歩", execute: ["２四歩", "同歩"])
            assert { container.hand_logs.last.to_kif_ki2 == ["２四歩(23)", "同歩"] }

            assert { container.opponent_player.executor.captured_soldier.piece.name == "歩" }
            assert { container.opponent_player.piece_box.to_s == "歩" }
            assert { container.opponent_player.to_s_soldiers == "２四歩" }
            assert { container.current_player.piece_box.to_s == "" }
            assert { container.current_player.to_s_soldiers == "" }
          end

          it "「同歩」ではなくわかりやすく「２四同歩」とした場合" do
            container = Container::Basic.facade(init: "▲２五歩 △２三歩", execute: ["２四歩", "２四同歩"])
            assert { container.hand_logs.last.to_kif_ki2 == ["２四歩(23)", "同歩"] }
          end

          it "２五の地点にたたみ掛けるときki2形式で同が連続すること" do
            container = Container::Basic.facade(init: "▲２七歩 ▲２八飛 △２三歩 △２二飛", execute: ["２六歩", "２四歩", "２五歩", "同歩", "同飛", "同飛"])
            assert { container.to_ki2_a == ["▲２六歩", "△２四歩", "▲２五歩", "△同歩", "▲同飛", "△同飛"] }
          end
        end

        describe "取れない" do
          it "初手に同歩" do
            expect { Container::Basic.facade(execute: "同歩") }.to raise_error(BeforePlaceNotFound, /同に対する座標が不明/)
          end
        end
      end
    end

    describe "打つ" do
      describe "打てる" do
        it "空いているところに" do
          assert { Container::Basic.player_test_soldier_names(execute: "５五歩打") == ["▲５五歩"] }
          assert { Container::Basic.player_test_soldier_names(execute: "５五歩合") == ["▲５五歩"] }
        end

        # 棋譜の表記方法：日本将棋連盟 http://www.shogi.or.jp/faq/kihuhyouki.html
        # > ※「打」と記入するのはあくまでもその地点に盤上の駒を動かすこともできる場合のみです。それ以外の場合は、持駒を打つ場合も「打」はつけません。
        it "打は曖昧なときだけ付く (このテストはログの変換のテストで入力のテストにはなっていない)" do
          assert { Container::Basic.player_test_soldier_names(execute: "５五歩") == ["▲５五歩"] }
          assert { Container::Basic.player_test(execute: "５五歩").container.hand_logs.last.to_kif == "５五歩打" }
        end

        it "２二角成としたけど盤上に何もないのそこに移動できる駒がひとつもないエラー" do
          expect { Container::Basic.player_test(execute: ["２二角成"]) }.to raise_error(MovableBattlerNotFound)
        end

        it "盤上に竜があってその横に飛を「打」をつけずに打った(打つときに他の駒もそこに来れそうなケース。実際は竜なので来れない)" do
          assert { Container::Basic.player_test(pieces_add: "飛", init: "１一龍", execute: "２一飛").container.hand_logs.last.to_kif == "２一飛打" }
        end

        it "と金は二歩にならないので" do
          assert { Container::Basic.player_test_soldier_names(init: "５五と", execute: "５六歩打") == ["▲５五と", "▲５六歩"] }
        end
      end

      describe "打てない" do
        it "場外に" do
          expect { Container::Basic.player_test_soldier_names(execute: "５十飛打") }.to raise_error(SyntaxDefact)
        end

        it "自分の駒の上に" do
          expect { Container::Basic.player_test_soldier_names(init: "５五飛", execute: "５五角打") }.to raise_error(PieceAlredyExist)
        end

        it "相手の駒の上に" do
          expect { Container::Basic.facade(execute: ["５五飛打", "５五角打"], pieces_set: "▼飛△角") }.to raise_error(PieceAlredyExist)
        end

        it "卍という駒がないので" do
          expect { Container::Basic.player_test_soldier_names(execute: "５五卍打") }.to raise_error(SyntaxDefact)
        end

        it "成った状態で" do
          expect { Container::Basic.player_test_soldier_names(execute: "５五龍打") }.to raise_error(PromotedPiecePutOnError)
        end

        it "１一歩打だとそれ以上動けないので" do
          expect { Container::Basic.player_test_soldier_names(execute: "１一歩打") }.to raise_error(DeadPieceRuleError)
        end

        it "二歩なので" do
          expect { Container::Basic.player_test_soldier_names(init: "５五歩", execute: "５九歩打") }.to raise_error(DoublePawnCommonError)
        end
      end

      describe "打の意味が重要なケース" do
        it "打を明示していないので駒を動かした" do
          assert { Container::Basic.player_test(pieces_add: "飛", init: "１一飛", execute: "１二飛").container.hand_logs.last.to_kif_ki2_csa == ["１二飛(11)", "１二飛不成", "+1112HI"] }
        end
        it "打を明示したので駒を打つ" do
          assert { Container::Basic.player_test(pieces_add: "飛", init: "１一飛", execute: "１二飛打").container.hand_logs.last.to_kif_ki2_csa == ["１二飛打", "１二飛打", "+0012HI"] }
          assert { Container::Basic.player_test(pieces_add: "飛", init: "１一飛", execute: "１二飛合").container.hand_logs.last.to_kif_ki2_csa == ["１二飛打", "１二飛打", "+0012HI"] }
        end
      end
    end

    it "指したあと前回の手を確認できる" do
      assert { Container::Basic.player_test(init: "５五飛", execute: "５一飛成").container.hand_logs.last.to_kif == "５一飛成(55)" }
      assert { Container::Basic.player_test(init: "５一龍", execute: "１一龍").container.hand_logs.last.to_kif   == "１一龍(51)" }
      assert { Container::Basic.player_test(execute: "５五飛打").container.hand_logs.last.to_kif                 == "５五飛打" }
    end

    it "持駒の確認" do
      assert { Container::Basic.player_test.piece_box.to_s == "玉 飛 角 金二 銀二 桂二 香二 歩九" }
    end

    it "全体確認" do
      container = Container.create
      container.placement_from_preset("平手")
      container.execute("７六歩")
      container.execute("３四歩")
      container.execute("２二角成")
      assert { container.player_at(:black).piece_box.to_s == "角" }
      expect(container.board.to_s).to eq(<<~EOT)
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
      assert { Container::Basic.facade(init: "▲２五歩 △２三歩", execute: ["２四歩", "同歩"]).hand_logs.last.to_kif_ki2 == ["２四歩(23)", "同歩"] }
    end

    it "「５八金(49)」を入力した結果からKI2変換したとき「58金右」となる" do
      # これはいままで ki2 入力でしか試していなかったため不具合を発見できなかった
      # 移動元が明確な kif で入力し、ki2 変換してみると candidate_soldiers が nil だったので「右」がつかなかった
      # 将棋DB2にも同様の不具合がある
      container = Container::Basic.start
      container.execute("５八金(49)")
      assert { container.hand_logs.first.to_ki2 == "５八金右" }
    end
  end
end
# >> Coverage report generated for RSpec to /Users/ikeda/src/bioshogi/coverage. 7 / 15 LOC (46.67%) covered.
# >> .......................F.......................................
# >>
# >> Failures:
# >>
# >>   1) Bioshogi::Player 移動 できる 相手の駒を動かそうとした
# >>      Failure/Error: Unable to find - to read failed line
# >>
# >>        expected Bioshogi::ReversePlayerPieceMoveError with message matching /【反則】相手の駒を動かそうとしています。1手目は先手の手番ですが後手の駒を持ちました.*もし平手で手番のハンデを貰っているなら☗側が初手を指してください/, got #<Bioshogi::ReversePlayerPieceMoveError: 【反則】相手の駒を動かそうとしています。手番違いかもしれません。1手目は☗の手番ですが☖が着手しました
# >>        手番: 先手
# >>        指...歩|七
# >>        | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
# >>        | 香 桂 銀 金 玉 金 銀 桂 香|九
# >>        +---------------------------+
# >>        先手の持駒：なし
# >>        手数＝0 まで
# >>
# >>        先手番> with backtrace:
# >>          # ./lib/bioshogi/player_executor_base.rb:131:in `raise_error'
# >>          # ./lib/bioshogi/player_executor_base.rb:37:in `perform_validations'
# >>          # ./lib/bioshogi/player_executor_base.rb:42:in `execute'
# >>          # ./lib/bioshogi/player.rb:23:in `execute'
# >>          # ./lib/bioshogi/xcontainer_executor.rb:31:in `block in execute'
# >>          # ./lib/bioshogi/xcontainer_executor.rb:30:in `each'
# >>          # ./lib/bioshogi/xcontainer_executor.rb:30:in `execute'
# >>          # -:110:in `block (5 levels) in <module:Bioshogi>'
# >>          # -:110:in `block (4 levels) in <module:Bioshogi>'
# >>      # -:110:in `block (4 levels) in <module:Bioshogi>'
# >>
# >> Top 10 slowest examples (0.08364 seconds, 43.4% of total time):
# >>   Bioshogi::Player 移動 できる 相手の駒を動かそうとした
# >>     0.02072 seconds -:108
# >>   Bioshogi::Player 座標を漢字・全角数字・半角数字のみでも指定できる
# >>     0.01854 seconds -:5
# >>   Bioshogi::Player 移動 成 成れない 自分の陣地から出るタイミングでも
# >>     0.01058 seconds -:156
# >>   Bioshogi::Player 指したあと前回の手を確認できる
# >>     0.00687 seconds -:311
# >>   Bioshogi::Player 打つ 打の意味が重要なケース 打を明示したので駒を打つ
# >>     0.00562 seconds -:304
# >>   Bioshogi::Player 初期配置
# >>     0.00439 seconds -:54
# >>   Bioshogi::Player 同
# >>     0.00437 seconds -:344
# >>   Bioshogi::Player 全体確認
# >>     0.00426 seconds -:321
# >>   Bioshogi::Player 打つ 打てる 空いているところに
# >>     0.0042 seconds -:245
# >>   Bioshogi::Player 打つ 打てる 打は曖昧なときだけ付く (このテストはログの変換のテストで入力のテストにはなっていない)
# >>     0.00406 seconds -:252
# >>
# >> Finished in 0.19285 seconds (files took 1.56 seconds to load)
# >> 63 examples, 1 failure
# >>
# >> Failed examples:
# >>
# >> rspec -:108 # Bioshogi::Player 移動 できる 相手の駒を動かそうとした
# >>
