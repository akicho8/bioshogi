require "spec_helper"

describe Bioshogi::Location do
  it "変換可能" do
    assert { Bioshogi::Location[-1].key      == :white }
    assert { Bioshogi::Location[0].key       == :black }
    assert { Bioshogi::Location[1].key       == :white }
    assert { Bioshogi::Location[2].key       == :black }
    assert { Bioshogi::Location[:black].key  == :black }
    assert { Bioshogi::Location["▲"].key    == :black }
    assert { Bioshogi::Location["▼"].key    == :black }
    assert { Bioshogi::Location["☗"].key    == :black }
    assert { Bioshogi::Location["b"].key     == :black }
  end

  it "これは微妙だけどないと困るので引けるようにする" do
    assert { Bioshogi::Location["先手"].key  == :black }
    assert { Bioshogi::Location["上手"].key  == :white }
  end

  it "手番と位置は異なる。先に指すからといって一方が特定できるわけではない(重要)" do
    expect { Bioshogi::Location.fetch("1手目") }.to raise_error(Bioshogi::BioshogiError)
    expect { Bioshogi::Location.fetch("3")     }.to raise_error(Bioshogi::BioshogiError)
  end

  it "盤面読み取り用" do
    assert { Bioshogi::Location[" "].key == :black }
    assert { Bioshogi::Location["v"].key == :white }
  end

  it "変換不能で nil" do
    assert { Bioshogi::Location["xxx"] == nil }
  end

  it "変換不能でエラー" do
    expect { Bioshogi::Location.fetch(nil)   }.to raise_error(Bioshogi::BioshogiError)
    expect { Bioshogi::Location.fetch("")    }.to raise_error(Bioshogi::BioshogiError)
    expect { Bioshogi::Location.fetch("foo") }.to raise_error(Bioshogi::BioshogiError)
  end

  it "簡潔に書きたいとき用" do
    assert { Bioshogi::Location[:black].key == :black }
    assert { Bioshogi::Location[:white].key == :white }
  end

  it "次の手番を返す" do
    assert { Bioshogi::Location[:white].flip.key == :black }
    assert { Bioshogi::Location[:white].next_location.key == :black }
  end

  it "属性っぽい値を全部返す" do
    assert { Bioshogi::Location[:black].match_target_values_set.kind_of?(Set) }
  end

  it "先手後手を表す文字一覧の正規表現" do
    assert { Bioshogi::Location.polygon_chars_str == "▲▼☗△▽☖" }
  end

  it "cssのstyle" do
    assert { Bioshogi::Location[:white].style_transform == "transform: rotate(180deg)" }
    assert { Bioshogi::Location[:black].style_transform == nil }
  end

  it "call_names" do
    assert { Bioshogi::Location.call_names == ["先手", "下手", "後手", "上手"] }
    assert { Bioshogi::Location[:black].call_names == ["先手", "下手"] }
  end

  it "位置から見た盤面の上下左右の座標を取得する" do
    assert { Bioshogi::Location[:black].bottom.name == "九" }
    assert { Bioshogi::Location[:black].top.name    == "一" }
    assert { Bioshogi::Location[:black].right.name  == "１" }
    assert { Bioshogi::Location[:black].left.name   == "９" }
    assert { Bioshogi::Location[:white].bottom.name == "一" }
    assert { Bioshogi::Location[:white].top.name    == "九" }
    assert { Bioshogi::Location[:white].left.name   == "１" }
    assert { Bioshogi::Location[:white].right.name  == "９" }
  end
end
# >> Bioshogi::Coverage report generated for Bioshogi::RSpec to /Bioshogi::Users/ikeda/src/bioshogi/coverage. 7 / 15 Bioshogi::LOC (46.67%) covered.
# >> ............
# >>
# >> Bioshogi::Top 10 slowest examples (0.01486 seconds, 61.0% of total time):
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
# >> Bioshogi::Finished in 0.02436 seconds (files took 1.98 seconds to load)
# >> 12 examples, 0 failures
# >>
