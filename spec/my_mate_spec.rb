require "spec_helper"

module Bioshogi
  describe Player do
    it "works" do
      container = Container::Basic.new
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

      ms = Benchmark.ms { container.player_at(:white).my_mate? }
      assert("詰む場合はそれなりに重い") { ms >= 20.0 }

      ms = Benchmark.ms { container.player_at(:black).my_mate? }
      assert("でも詰まない場合の処理は早い") { ms < 0.2 }
    end
  end
end
