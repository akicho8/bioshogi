# 昔作ったテストでコンパクトにしたぶん何をテストしているのか判然としなくなっているもの

require "spec_helper"

module Bioshogi
  describe "将棋連盟が定めている人間向け棋譜入力" do
    before do
      @params = {pieces_add: "飛 角 銀"}
    end

    describe "http://www.shogi.or.jp/faq/kihuhyouki.html" do
      describe "龍" do
        it "パターンA" do
          @params.update(init: ["９一龍", "８四龍"])
          assert { Container::Basic.read_spec(@params.merge(execute: "８二龍引")) == ["８二龍(91)", "８二龍引"] }
          assert { Container::Basic.read_spec(@params.merge(execute: "８二龍上")) == ["８二龍(84)", "８二龍上"] }
        end
        it "パターンB" do
          @params.update(init: ["５二龍", "２三龍"])
          assert { Container::Basic.read_spec(@params.merge(execute: "４三龍寄")) == ["４三龍(23)", "４三龍寄"] }
          assert { Container::Basic.read_spec(@params.merge(execute: "４三龍引")) == ["４三龍(52)", "４三龍引"] }
        end
        it "パターンC" do
          @params.update(init: ["５五龍", "１五龍"])
          assert { Container::Basic.read_spec(@params.merge(execute: "３五龍左")) == ["３五龍(55)", "３五龍左"] }
          assert { Container::Basic.read_spec(@params.merge(execute: "３五龍右")) == ["３五龍(15)", "３五龍右"] }
        end
        it "パターンD" do
          @params.update(init: ["９九龍", "８九龍"])
          assert { Container::Basic.read_spec(@params.merge(execute: "８八龍左")) == ["８八龍(99)", "８八龍左"] }
          assert { Container::Basic.read_spec(@params.merge(execute: "８八龍右")) == ["８八龍(89)", "８八龍右"] }
        end
        it "パターンE" do
          @params.update(init: ["２八龍", "１九龍"])
          assert { Container::Basic.read_spec(@params.merge(execute: "１七龍左")) == ["１七龍(28)", "１七龍左"] }
          assert { Container::Basic.read_spec(@params.merge(execute: "１七龍右")) == ["１七龍(19)", "１七龍右"] }
        end
      end

      describe "馬" do
        it "パターンA" do
          @params.update(init: ["９一馬", "８一馬"])
          assert { Container::Basic.read_spec(@params.merge(execute: "８二馬左")) == ["８二馬(91)", "８二馬左"] }
          assert { Container::Basic.read_spec(@params.merge(execute: "８二馬右")) == ["８二馬(81)", "８二馬右"] }
        end
        it "パターンB" do
          @params.update(init: ["９五馬", "６三馬"])
          assert { Container::Basic.read_spec(@params.merge(execute: "８五馬寄")) == ["８五馬(95)", "８五馬寄"] }
          assert { Container::Basic.read_spec(@params.merge(execute: "８五馬引")) == ["８五馬(63)", "８五馬引"] }
        end
        it "パターンC" do
          @params.update(init: ["１一馬", "３四馬"])
          assert { Container::Basic.read_spec(@params.merge(execute: "１二馬引")) == ["１二馬(11)", "１二馬引"] }
          assert { Container::Basic.read_spec(@params.merge(execute: "１二馬上")) == ["１二馬(34)", "１二馬上"] }
        end
        it "パターンD" do
          @params.update(init: ["９九馬", "５九馬"])
          assert { Container::Basic.read_spec(@params.merge(execute: "７七馬左")) == ["７七馬(99)", "７七馬左"] }
          assert { Container::Basic.read_spec(@params.merge(execute: "７七馬右")) == ["７七馬(59)", "７七馬右"] }
        end
        it "パターンE" do
          @params.update(init: ["４七馬", "１八馬"])
          assert { Container::Basic.read_spec(@params.merge(execute: "２九馬左")) == ["２九馬(47)", "２九馬左"] }
          assert { Container::Basic.read_spec(@params.merge(execute: "２九馬右")) == ["２九馬(18)", "２九馬右"] }
        end
      end
    end

    it "真右だけ" do
      @params.update({init: [
            "______", "______", "______",
            "______", "______", "４五と",
            "______", "______", "______",
          ]})
      assert { Container::Basic.read_spec(@params.merge(execute: "５五と")) == ["５五と(45)", "５五と"] }
    end

    it "右下だけ" do
      @params.update({init: [
            "______", "______", "______",
            "______", "______", "______",
            "______", "______", "４六と",
          ]})
      assert { Container::Basic.read_spec(@params.merge(execute: "５五と")) == ["５五と(46)", "５五と"] }
    end

    it "真下だけ" do
      @params.update({init: [
            "______", "______", "______",
            "______", "______", "______",
            "______", "５六と", "______",
          ]})
      assert { Container::Basic.read_spec(@params.merge(execute: "５五と")) == ["５五と(56)", "５五と"] }
    end

    it "下面" do
      @params.update({init: [
            "______", "______", "______",
            "______", "______", "______",
            "６六と", "５六と", "４六と",
          ]})
      assert { Container::Basic.read_spec(@params.merge(execute: "５五と右")) == ["５五と(46)", "５五と右"] }
      assert { Container::Basic.read_spec(@params.merge(execute: "５五と直")) == ["５五と(56)", "５五と直"] }
      assert { Container::Basic.read_spec(@params.merge(execute: "５五と左")) == ["５五と(66)", "５五と左"] }
    end

    it "左下と下" do
      @params.update({init: [
            "______", "______", "______",
            "______", "______", "______",
            "６六と", "５六と", "______",
          ]})
      assert { Container::Basic.read_spec(@params.merge(execute: "５五と左")) == ["５五と(66)", "５五と左"] }
      assert { Container::Basic.read_spec(@params.merge(execute: "５五と直")) == ["５五と(56)", "５五と直"] }
    end

    it "縦に二つ" do
      @params.update({init: [
            "______", "５四と", "______",
            "______", "______", "______",
            "______", "５六と", "______",
          ]})
      assert { Container::Basic.read_spec(@params.merge(execute: "５五と引")) == ["５五と(54)", "５五と引"] }
      assert { Container::Basic.read_spec(@params.merge(execute: "５五と上")) == ["５五と(56)", "５五と上"] }
    end

    it "左と左下" do
      @params.update({init: [
            "______", "______", "______",
            "６五と", "______", "______",
            "６六と", "______", "______",
          ]})
      assert { Container::Basic.read_spec(@params.merge(execute: "５五と寄")) == ["５五と(65)", "５五と寄"] }
      assert { Container::Basic.read_spec(@params.merge(execute: "５五と上")) == ["５五と(66)", "５五と上"] }
    end

    it "左上と左下" do
      @params.update({init: [
            "６四銀", "______", "______",
            "______", "______", "______",
            "６六銀", "______", "______",
          ]})
      assert { Container::Basic.read_spec(@params.merge(execute: "５五銀引")) == ["５五銀(64)", "５五銀引"] }
      assert { Container::Basic.read_spec(@params.merge(execute: "５五銀上")) == ["５五銀(66)", "５五銀上"] }
    end

    it "左右" do
      @params.update({init: [
            "______", "______", "______",
            "６五と", "______", "４五と",
            "______", "______", "______",
          ]})
      assert { Container::Basic.read_spec(@params.merge(execute: "５五と左")) == ["５五と(65)", "５五と左"] }
      assert { Container::Basic.read_spec(@params.merge(execute: "５五と右")) == ["５五と(45)", "５五と右"] }
    end

    describe "打" do
      it "基本表示しない" do
        @params.update({init: [
              "______", "______", "______",
              "______", "______", "______",
              "______", "______", "______",
            ]})
        assert { Container::Basic.read_spec(@params.merge(execute: "５五銀")) == ["５五銀打", "５五銀"] }
      end

      it "盤上の駒1つ移動と重複するため明示" do
        @params.update({init: [
              "______", "______", "______",
              "______", "______", "______",
              "______", "５六銀", "______",
            ]})
        assert { Container::Basic.read_spec(@params.merge(execute: "５五銀打")) == ["５五銀打", "５五銀打"] }
      end

      it "盤上の駒2つ以上の移動と重複するため明示(盤上の重複の解決処理と打の関係)" do
        @params.update({init: [
              "______", "______", "______",
              "______", "______", "______",
              "６六銀", "５六銀", "______",
            ]})
        assert { Container::Basic.read_spec(@params.merge(execute: "５五銀打")) == ["５五銀打", "５五銀打"] }
      end
    end

    it "直と不成が重なるとき「不成」と「直」の方が先にくる" do
      assert { Container::Basic.read_spec(init: ["３四銀", "２四銀"], execute: "２三銀直不成") == ["２三銀(24)", "２三銀直不成"] }
    end

    it "２三銀引成できる" do
      assert { Container::Basic.read_spec(init: ["３二銀", "３四銀"], execute: "２三銀引成") == ["２三銀成(32)", "２三銀引成"] }
    end

    it "「直上」ではなく「直」になる" do
      assert { Container::Basic.read_spec(init: ["２九金", "１九金"], execute: "２八金直") == ["２八金(29)", "２八金直"] }
    end
  end
end
