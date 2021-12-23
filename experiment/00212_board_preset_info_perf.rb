require "./setup"
rows = nil
total = Benchmark.ms do
  rows = PresetInfo.collect do |e|
    board = Board.new
    board.placement_from_preset(e.key)
    preset_info = nil
    ms = Benchmark.ms do
      preset_info = board.preset_info
    end
    { key: preset_info&.name, ms: "%.3f" % ms }
  end
end
p total
tp rows
# >> 23.690000001806766
# >> |------------+-------|
# >> | key        | ms    |
# >> |------------+-------|
# >> | 平手       | 0.052 |
# >> | 5五将棋    | 0.020 |
# >> | 香落ち     | 0.047 |
# >> | 右香落ち   | 0.057 |
# >> | 角落ち     | 0.094 |
# >> | 飛車落ち   | 0.072 |
# >> | 飛香落ち   | 0.049 |
# >> | 二枚落ち   | 0.087 |
# >> | 三枚落ち   | 0.055 |
# >> | 四枚落ち   | 0.049 |
# >> | 六枚落ち   | 0.053 |
# >> | 八枚落ち   | 0.062 |
# >> | 十枚落ち   | 0.050 |
# >> | 十九枚落ち | 0.038 |
# >> | 二十枚落ち | 0.038 |
# >> |------------+-------|
