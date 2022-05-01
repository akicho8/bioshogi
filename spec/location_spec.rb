require "spec_helper"

module Bioshogi
  describe LocationInfo do
    it "変換可能" do
      assert { LocationInfo[-1].key      == :white }
      assert { LocationInfo[0].key       == :black }
      assert { LocationInfo[1].key       == :white }
      assert { LocationInfo[2].key       == :black }
      assert { LocationInfo[:black].key  == :black }
      assert { LocationInfo["▲"].key    == :black }
      assert { LocationInfo["▼"].key    == :black }
      assert { LocationInfo["☗"].key    == :black }
      assert { LocationInfo["b"].key     == :black }
    end

    it "これは微妙だけどないと困るので引けるようにする" do
      assert { LocationInfo["先手"].key  == :black }
      assert { LocationInfo["上手"].key  == :white }
    end

    it "手番と位置は異なる。先に指すからといって一方が特定できるわけではない(重要)" do
      expect { LocationInfo.fetch("1手目") }.to raise_error(BioshogiError)
      expect { LocationInfo.fetch("3")     }.to raise_error(BioshogiError)
    end

    it "盤面読み取り用" do
      assert { LocationInfo[" "].key == :black }
      assert { LocationInfo["v"].key == :white }
    end

    it "変換不能で nil" do
      assert { LocationInfo["xxx"] == nil }
    end

    it "変換不能でエラー" do
      expect { LocationInfo.fetch(nil)   }.to raise_error(BioshogiError)
      expect { LocationInfo.fetch("")    }.to raise_error(BioshogiError)
      expect { LocationInfo.fetch("foo") }.to raise_error(BioshogiError)
    end

    it "簡潔に書きたいとき用" do
      assert { LocationInfo[:black].key == :black }
      assert { LocationInfo[:white].key == :white }
    end

    it "次の手番を返す" do
      assert { LocationInfo[:white].flip.key == :black }
      assert { LocationInfo[:white].next_location.key == :black }
    end

    it "属性っぽい値を全部返す" do
      assert { LocationInfo[:black].match_target_values_set.kind_of?(Set) }
    end

    it "先手後手を表す文字一覧の正規表現" do
      assert { LocationInfo.polygon_chars_str == "▲▼☗△▽☖" }
    end

    it "cssのstyle" do
      assert { LocationInfo[:white].style_transform == "transform: rotate(180deg)" }
      assert { LocationInfo[:black].style_transform == nil }
    end

    it "call_names" do
      assert { LocationInfo.call_names == ["先手", "下手", "後手", "上手"] }
      assert { LocationInfo[:black].call_names == ["先手", "下手"] }
    end
  end
end
# >> Coverage report generated for RSpec to /Users/ikeda/src/bioshogi/coverage. 7 / 15 LOC (46.67%) covered.
# >> ............
# >> 
# >> Top 10 slowest examples (0.01486 seconds, 61.0% of total time):
# >>   Bioshogi::LocationInfo 変換可能
# >>     0.01027 seconds -:5
# >>   Bioshogi::LocationInfo 手番と位置は異なる。先に指すからといって一方が特定できるわけではない(重要)
# >>     0.00285 seconds -:22
# >>   Bioshogi::LocationInfo 盤面読み取り用
# >>     0.00031 seconds -:27
# >>   Bioshogi::LocationInfo これは微妙だけどないと困るので引けるようにする
# >>     0.00027 seconds -:17
# >>   Bioshogi::LocationInfo 次の手番を返す
# >>     0.00022 seconds -:47
# >>   Bioshogi::LocationInfo call_names
# >>     0.0002 seconds -:65
# >>   Bioshogi::LocationInfo cssのstyle
# >>     0.0002 seconds -:60
# >>   Bioshogi::LocationInfo 簡潔に書きたいとき用
# >>     0.0002 seconds -:42
# >>   Bioshogi::LocationInfo 変換不能でエラー
# >>     0.00018 seconds -:36
# >>   Bioshogi::LocationInfo 変換不能で nil
# >>     0.00016 seconds -:32
# >> 
# >> Finished in 0.02436 seconds (files took 1.98 seconds to load)
# >> 12 examples, 0 failures
# >> 
