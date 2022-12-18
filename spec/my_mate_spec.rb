require "spec_helper"

module Bioshogi
  describe Player do
    it "works" do
      container = Container.create
      container.placement_from_bod <<~EOT
      後手の持駒：飛角金銀桂香歩
      +------+
      | ・v玉|
      | ・ 金|
      | ・ 金|
      +------+
      先手の持駒：飛角金銀桂香歩
      手数＝1
      EOT
      assert { container.player_at(:black).my_mate? == false }
      assert { container.player_at(:black).op_mate? == true  }
      assert { container.player_at(:white).my_mate? == true  }
      assert { container.player_at(:white).op_mate? == false }

      # 詰む場合はそれなに重い
      ms = Benchmark.ms { container.player_at(:white).my_mate? }
      assert { ms >= 50.0 }

      # でも詰まない場合の処理は早い
      ms = Benchmark.ms { container.player_at(:black).my_mate? }
      assert { ms < 0.2 }
    end
  end
end
