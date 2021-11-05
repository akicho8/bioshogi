require "spec_helper"

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

    it "call_names" do
      assert { Location.call_names == ["先手", "下手", "後手", "上手"] }
      assert { Location[:black].call_names == ["先手", "下手"] }
    end
  end
end
# >> Coverage report generated for RSpec to /Users/ikeda/src/bioshogi/coverage. 7 / 15 LOC (46.67%) covered.
# >> ............
# >> 
# >> Top 10 slowest examples (0.01486 seconds, 61.0% of total time):
# >>   Bioshogi::Location 変換可能
# >>     0.01027 seconds -:5
# >>   Bioshogi::Location 手番と位置は異なる。先に指すからといって一方が特定できるわけではない(重要)
# >>     0.00285 seconds -:22
# >>   Bioshogi::Location 盤面読み取り用
# >>     0.00031 seconds -:27
# >>   Bioshogi::Location これは微妙だけどないと困るので引けるようにする
# >>     0.00027 seconds -:17
# >>   Bioshogi::Location 次の手番を返す
# >>     0.00022 seconds -:47
# >>   Bioshogi::Location call_names
# >>     0.0002 seconds -:65
# >>   Bioshogi::Location cssのstyle
# >>     0.0002 seconds -:60
# >>   Bioshogi::Location 簡潔に書きたいとき用
# >>     0.0002 seconds -:42
# >>   Bioshogi::Location 変換不能でエラー
# >>     0.00018 seconds -:36
# >>   Bioshogi::Location 変換不能で nil
# >>     0.00016 seconds -:32
# >> 
# >> Finished in 0.02436 seconds (files took 1.98 seconds to load)
# >> 12 examples, 0 failures
# >> 
