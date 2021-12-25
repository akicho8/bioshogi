require "./setup"
GC.disable
rows = nil
total = Benchmark.ms do
  rows = PresetInfo.collect do |e|
    board = Board.new
    board.placement_from_preset(e.key)
    preset_info = nil
    n = 200
    board.preset_info(optimize: true)
    ms1 = Benchmark.ms { n.times { preset_info = board.preset_info(optimize: false) } }
    ms2 = Benchmark.ms { n.times { preset_info = board.preset_info(optimize: true)  } }
    { key: preset_info&.name, ms1: "%.3f" % ms1, ms2: "%.3f" % ms2 }
  end
end
p total
tp rows
# >> 336.37399997678585
# >> |----------------+--------+--------|
# >> | key            | ms1    | ms2    |
# >> |----------------+--------+--------|
# >> | 平手           |  8.679 |  8.735 |
# >> | 香落ち         |  8.836 |  8.484 |
# >> | 右香落ち       |  9.611 |  9.621 |
# >> | 角落ち         | 16.930 | 16.676 |
# >> | 飛車落ち       | 13.588 | 12.823 |
# >> | 飛香落ち       |  9.742 |  8.113 |
# >> | 二枚落ち       | 16.372 | 16.159 |
# >> | 三枚落ち       |  9.668 |  8.142 |
# >> | 四枚落ち       |  9.744 |  7.882 |
# >> | 六枚落ち       |  9.744 |  7.431 |
# >> | 八枚落ち       |  9.162 |  7.195 |
# >> | 十枚落ち       |  8.920 |  6.633 |
# >> | 十九枚落ち     |  7.391 |  5.746 |
# >> | 二十枚落ち     |  7.236 |  4.604 |
# >> | 5五将棋        |  5.857 |  2.991 |
# >> | 青空将棋       |  8.149 |  5.041 |
# >> | バリケード将棋 |  8.736 |  5.163 |
# >> |----------------+--------+--------|
