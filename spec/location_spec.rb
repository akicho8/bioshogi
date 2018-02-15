require_relative "spec_helper"

module Warabi
  describe Location do
    it "変換可能" do
      Location[-1].key.should      == :white
      Location[0].key.should       == :black
      Location[1].key.should       == :white
      Location[2].key.should       == :black
      Location[:black].key.should  == :black
      Location["▲"].key.should    == :black
      Location["▼"].key.should    == :black
      Location["☗"].key.should    == :black
      Location["b"].key.should     == :black
    end

    it "これは微妙だけどないと困るので引けるようにする" do
      Location["先手"].key.should  == :black
      Location["上手"].key.should  == :white
    end

    it "手番と位置は異なる。先に指すからといって一方が特定できるわけではない(重要)" do
      expect { Location.fetch("1手目") }.to raise_error(WarabiError)
      expect { Location.fetch("3")     }.to raise_error(WarabiError)
    end

    it "盤面読み取り用" do
      Location[" "].key.should == :black
      Location["v"].key.should == :white
    end

    it "変換不能で nil" do
      Location["xxx"].should == nil
    end

    it "変換不能でエラー" do
      expect { Location.fetch(nil)   }.to raise_error(WarabiError)
      expect { Location.fetch("")    }.to raise_error(WarabiError)
      expect { Location.fetch("foo") }.to raise_error(WarabiError)
    end

    it "簡潔に書きたいとき用" do
      Location[:black].key.should == :black
      Location[:white].key.should == :white
    end

    it "次の手番を返す" do
      Location[:white].flip.key.should == :black
      Location[:white].next_location.key.should == :black
    end

    it "属性っぽい値を全部返す" do
      Location[:black].match_target_values_set.should be_an_instance_of Set
    end

    it "先手後手を表す文字一覧の正規表現" do
      Location.triangles_str.should == "▲▼△▽"
    end

    it "cssのstyle" do
      Location[:white].style_transform.should == "transform: rotate(180deg)"
      Location[:black].style_transform.should == nil
    end
  end
end
