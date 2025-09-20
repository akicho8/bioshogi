require "#{__dir__}/setup"
GC.disable
rows = nil
total = Benchmark.ms do
  rows = PresetInfo.collect do |e|
    board = Board.new
    board.placement_from_preset(e.key)
    preset_info = nil
    n = 200
    ms = Benchmark.ms { n.times { preset_info = board.preset_info } }
    { key: preset_info&.name, ms: "%.3f" % ms, }
  end
end
p total
tp rows
# >> 229.3459998909384
# >> |----------+--------|
# >> | key      | ms     |
# >> |----------+--------|
# >> | 平手     |  8.685 |
# >> | 香落ち   |  8.945 |
# >> |          | 24.589 |
# >> | 角落ち   | 16.155 |
# >> | 飛車落ち | 12.483 |
# >> | 飛香落ち |  9.267 |
# >> | 二枚落ち | 16.759 |
# >> | 二枚落ち | 23.834 |
# >> | 三枚落ち |  9.580 |
# >> | 四枚落ち |  9.530 |
# >> | 六枚落ち |  9.697 |
# >> |          | 10.812 |
# >> | 八枚落ち |  9.182 |
# >> | 十枚落ち |  8.965 |
# >> |          |  7.246 |
# >> |          |  6.582 |
# >> |          |  7.408 |
# >> |          |  7.059 |
# >> |          |  5.258 |
# >> |----------+--------|
