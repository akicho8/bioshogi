require_relative "spec_helper"

module Bioshogi
  describe Location do
    it "変換可能" do
      assert { Location[-1].key      == :white }
      assert { Location[0].key       == :black }
      assert { Location[1].key       == :white }
      assert { Location[2].key       == :black }
      assert { Location[:black].key  == :black }
      assert { Location["▲"].key    == :black }
      assert { Location["▼"].key    == :black }
      assert { Location["☗"].key    == :black }
      assert { Location["b"].key     == :black }
    end

    it "これは微妙だけどないと困るので引けるようにする" do
      assert { Location["先手"].key  == :black }
      assert { Location["上手"].key  == :white }
    end

    it "手番と位置は異なる。先に指すからといって一方が特定できるわけではない(重要)" do
      expect { Location.fetch("1手目") }.to raise_error(BioshogiError)
      expect { Location.fetch("3")     }.to raise_error(BioshogiError)
    end

    it "盤面読み取り用" do
      assert { Location[" "].key == :black }
      assert { Location["v"].key == :white }
    end

    it "変換不能で nil" do
      assert { Location["xxx"] == nil }
    end

    it "変換不能でエラー" do
      expect { Location.fetch(nil)   }.to raise_error(BioshogiError)
      expect { Location.fetch("")    }.to raise_error(BioshogiError)
      expect { Location.fetch("foo") }.to raise_error(BioshogiError)
    end

    it "簡潔に書きたいとき用" do
      assert { Location[:black].key == :black }
      assert { Location[:white].key == :white }
    end

    it "次の手番を返す" do
      assert { Location[:white].flip.key == :black }
      assert { Location[:white].next_location.key == :black }
    end

    it "属性っぽい値を全部返す" do
      assert { Location[:black].match_target_values_set.kind_of?(Set) }
    end

    it "先手後手を表す文字一覧の正規表現" do
      assert { Location.polygon_chars_str == "▲▼☗△▽☖" }
    end

    it "cssのstyle" do
      assert { Location[:white].style_transform == "transform: rotate(180deg)" }
      assert { Location[:black].style_transform == nil }
    end
  end
end
