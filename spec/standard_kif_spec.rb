require_relative "spec_helper"

module Bushido
  describe "将棋連盟が定めている人間向け棋譜入力" do
    before do
      @params = {append_pieces: "飛 角"}
    end

    describe "http://www.shogi.or.jp/faq/kihuhyouki.html" do
      describe "龍" do
        it "パターンA" do
          @params.update(init: ["９一龍", "８四龍"])
          read_spec(@params.merge(exec: "８二龍引")).should == ["8二龍(91)", "8二龍引"]
          read_spec(@params.merge(exec: "８二龍上")).should == ["8二龍(84)", "8二龍上"]
        end
        it "パターンB" do
          @params.update(init: ["５二龍", "２三龍"])
          read_spec(@params.merge(exec: "４三龍寄")).should == ["4三龍(23)", "4三龍寄"]
          read_spec(@params.merge(exec: "４三龍引")).should == ["4三龍(52)", "4三龍引"]
        end
        it "パターンC" do
          @params.update(init: ["５五龍", "１五龍"])
          read_spec(@params.merge(exec: "３五龍左")).should == ["3五龍(55)", "3五龍左"]
          read_spec(@params.merge(exec: "３五龍右")).should == ["3五龍(15)", "3五龍右"]
        end
        it "パターンD" do
          @params.update(init: ["９九龍", "８九龍"])
          read_spec(@params.merge(exec: "８八龍左")).should == ["8八龍(99)", "8八龍左"]
          read_spec(@params.merge(exec: "８八龍右")).should == ["8八龍(89)", "8八龍右"]
        end
        it "パターンE" do
          @params.update(init: ["２八龍", "１九龍"])
          read_spec(@params.merge(exec: "１七龍左")).should == ["1七龍(28)", "1七龍左"]
          read_spec(@params.merge(exec: "１七龍右")).should == ["1七龍(19)", "1七龍右"]
        end
      end

      describe "馬" do
        it "パターンA" do
          @params.update(init: ["９一馬", "８一馬"])
          read_spec(@params.merge(exec: "８二馬左")).should == ["8二馬(91)", "8二馬左"]
          read_spec(@params.merge(exec: "８二馬右")).should == ["8二馬(81)", "8二馬右"]
        end
        it "パターンB" do
          @params.update(init: ["９五馬", "６三馬"])
          read_spec(@params.merge(exec: "８五馬寄")).should == ["8五馬(95)", "8五馬寄"]
          read_spec(@params.merge(exec: "８五馬引")).should == ["8五馬(63)", "8五馬引"]
        end
        it "パターンC" do
          @params.update(init: ["１一馬", "３四馬"])
          read_spec(@params.merge(exec: "１二馬引")).should == ["1二馬(11)", "1二馬引"]
          read_spec(@params.merge(exec: "１二馬上")).should == ["1二馬(34)", "1二馬上"]
        end
        it "パターンD" do
          @params.update(init: ["９九馬", "５九馬"])
          read_spec(@params.merge(exec: "７七馬左")).should == ["7七馬(99)", "7七馬左"]
          read_spec(@params.merge(exec: "７七馬右")).should == ["7七馬(59)", "7七馬右"]
        end
        it "パターンE" do
          @params.update(init: ["４七馬", "１八馬"])
          read_spec(@params.merge(exec: "２九馬左")).should == ["2九馬(47)", "2九馬左"]
          read_spec(@params.merge(exec: "２九馬右")).should == ["2九馬(18)", "2九馬右"]
        end
      end
    end

    it "真右だけ" do
      @params.update({init: [
            "______", "______", "______",
            "______", "______", "４五と",
            "______", "______", "______",
          ]})
      read_spec(@params.merge(exec: "５五と")).should == ["5五と(45)", "5五と"]
    end

    it "右下だけ" do
      @params.update({init: [
            "______", "______", "______",
            "______", "______", "______",
            "______", "______", "４六と",
          ]})
      read_spec(@params.merge(exec: "５五と")).should == ["5五と(46)", "5五と"]
    end

    it "真下だけ" do
      @params.update({init: [
            "______", "______", "______",
            "______", "______", "______",
            "______", "５六と", "______",
          ]})
      read_spec(@params.merge(exec: "５五と")).should == ["5五と(56)", "5五と"]
    end

    it "下面" do
      @params.update({init: [
            "______", "______", "______",
            "______", "______", "______",
            "６六と", "５六と", "４六と",
          ]})
      read_spec(@params.merge(exec: "５五と右")).should == ["5五と(46)", "5五と右"]
      read_spec(@params.merge(exec: "５五と直")).should == ["5五と(56)", "5五と直"]
      read_spec(@params.merge(exec: "５五と左")).should == ["5五と(66)", "5五と左"]
    end

    it "縦に二つ" do
      @params.update({init: [
            "______", "５四と", "______",
            "______", "______", "______",
            "______", "５六と", "______",
          ]})
      read_spec(@params.merge(exec: "５五と引")).should == ["5五と(54)", "5五と引"]
      read_spec(@params.merge(exec: "５五と上")).should == ["5五と(56)", "5五と上"]
    end

    it "左と左下" do
      @params.update({init: [
            "______", "______", "______",
            "６五と", "______", "______",
            "６六と", "______", "______",
          ]})
      read_spec(@params.merge(exec: "５五と寄")).should == ["5五と(65)", "5五と寄"]
      read_spec(@params.merge(exec: "５五と上")).should == ["5五と(66)", "5五と上"]
    end

    it "左上と左下" do
      @params.update({init: [
            "６四銀", "______", "______",
            "______", "______", "______",
            "６六銀", "______", "______",
          ]})
      read_spec(@params.merge(exec: "５五銀引")).should == ["5五銀(64)", "5五銀引"]
      read_spec(@params.merge(exec: "５五銀上")).should == ["5五銀(66)", "5五銀上"]
    end

    it "左右" do
      @params.update({init: [
            "______", "______", "______",
            "６五と", "______", "４五と",
            "______", "______", "______",
          ]})
      read_spec(@params.merge(exec: "５五と左")).should == ["5五と(65)", "5五と左"]
      read_spec(@params.merge(exec: "５五と右")).should == ["5五と(45)", "5五と右"]
    end

    it "同" do
      Mediator.test(init: "▲２五歩 △２三歩", exec: ["２四歩", "同歩"]).reverse_player.runner.hand_log.to_kif_ki2.should == ["2四歩(23)", "同歩"]
    end

    it "直と不成が重なるとき「不成」と「直」の方が先にくる" do
      read_spec(init: ["３四銀", "２四銀"], exec: "２三銀直不成").should == ["2三銀(24)", "2三銀直不成"]
    end

    it "２三銀引成できる？" do
      read_spec(init: ["３二銀", "３四銀"], exec: "２三銀引成").should == ["2三銀成(32)", "2三銀引成"]
    end
  end
end
