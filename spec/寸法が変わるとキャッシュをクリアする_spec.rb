# 全体テストをするとここが通ってしまう
# 正しくキャッシュがクリアできていなければ単体でこれを実行すれば失敗する

require "spec_helper"

describe "寸法が変わるとキャッシュをクリアする" do
  it "works" do
    container = Bioshogi::Container::Basic.new

    Bioshogi::Dimension.change([2, 3]) do
      container = Bioshogi::Container::Basic.new
      container.placement_from_bod <<~EOT
      +------+
        | ・v玉|
    | ・v角|
    | 玉 香|
      +------+
        手数＝1
      EOT
      container.current_player.move_hands(promoted_only: true).collect(&:to_s) # =>
    end

    # ここでは 9x9 に戻っている
    container = Bioshogi::Container::Basic.new
    container.board.placement_from_shape(<<~EOT)
    +---------+
    | ・v銀 ・|
    | ・ ○ ・|
    |v銀 ・ ・|
    +---------+
      EOT
    container.next_player.execute("22銀上")
    # 寸法を変更したときの情報がインスタンスに残っているとここで "２二銀上不成" となる
    assert { container.hand_logs.last.to_ki2 == "２二銀上" }
  end
end
# >> Bioshogi::Coverage report generated for Bioshogi::RSpec to /Bioshogi::Users/ikeda/src/bioshogi/coverage. 5 / 13 Bioshogi::LOC (38.46%) covered.
# >> F
# >>
# >> Bioshogi::Failures:
# >>
# >>   1) 寸法が変わるとキャッシュをクリアする works
# >>      Bioshogi::Failure/Bioshogi::Error: Bioshogi::Unable to find - to read failed line
# >>
# >>      Bioshogi::NoMethodError:
# >>        undefined method `change' for Bioshogi::Dimension:Module
# >>      # -:11:in `block (2 levels) in <# >>
# >> Bioshogi::Top 1 slowest examples (0.00127 seconds, 5.1% of total time):
# >>   寸法が変わるとキャッシュをクリアする works
# >>     0.00127 seconds -:8
# >>
# >> Bioshogi::Finished in 0.02488 seconds (files took 2.58 seconds to load)
# >> 1 example, 1 failure
# >>
# >> Bioshogi::Failed examples:
# >>
# >> rspec -:8 # 寸法が変わるとキャッシュをクリアする works
# >>
