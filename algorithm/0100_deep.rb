require 'active_support/core_ext/benchmark'

require "./dirty_minimax"
require "./beauty_minimax"
require "./nega_max"
require "./nega_alpha"

dimension = 5
rows = [
  # DirtyMinimax,
  NegaMax,
  NegaAlpha,
].flat_map do |model|
  (3..8).collect do |depth_max|
    obj = model.new
    obj.params[:silent] = true
    obj.params[:depth_max_range] = 1..depth_max
    obj.params[:time_limit] = 0.05
    obj.params[:dimension] = dimension
    obj.params[:times] = 2
    ms = Benchmark.ms { obj.run }
    row = {}
    row[:model] = model.name
    row[:depth_max_range] = 1..depth_max
    row.update(obj.app.run_counts)
    row.update(turn: obj.current_turn.next)
    row.update(obj.app.histogram)
    row.update(obj.app.same_pos.values.group_by(&:itself).transform_values(&:size))
    row.update("指し手1手平均(ms)": "%.2f" % (ms / obj.current_turn.next))
  end
end
tp rows
# >> |-----------+-----------------+--------+----------+------+---+---+------+----+-----+-------------------+-----+---+---+---|
# >> | model     | depth_max_range | put_on | evaluate | turn | o | x |    1 |  3 |   2 | 指し手1手平均(ms) | TLE | 4 | 5 | 6 |
# >> |-----------+-----------------+--------+----------+------+---+---+------+----+-----+-------------------+-----+---+---+---|
# >> | NegaMax   | 1..3            |    597 |      441 |    2 | 3 | 3 |  321 |  6 |  51 |             59.48 |     |   |   |   |
# >> | NegaMax   | 1..4            |   2125 |     1606 |    2 | 3 | 3 | 1108 | 19 | 207 |            201.01 |   2 | 3 | 3 |   |
# >> | NegaMax   | 1..5            |   2279 |     1722 |    2 | 3 | 3 | 1210 | 19 | 214 |            210.07 |   2 | 3 | 3 |   |
# >> | NegaMax   | 1..6            |   2252 |     1702 |    2 | 3 | 3 | 1190 | 19 | 214 |            207.57 |   2 | 3 | 3 |   |
# >> | NegaMax   | 1..7            |   2129 |     1609 |    2 | 3 | 3 | 1113 | 19 | 206 |            206.47 |   2 | 3 | 3 |   |
# >> | NegaMax   | 1..8            |   2044 |     1545 |    2 | 3 | 3 | 1057 | 19 | 202 |            206.60 |   2 | 3 | 3 |   |
# >> | NegaAlpha | 1..3            |    336 |      216 |    2 | 3 | 3 |  162 |  4 |  21 |             48.43 |     |   |   |   |
# >> | NegaAlpha | 1..4            |    757 |      470 |    2 | 3 | 3 |  364 | 10 |  34 |            109.38 |   1 | 2 |   |   |
# >> | NegaAlpha | 1..5            |   1532 |      915 |    2 | 3 | 3 |  622 | 33 |  72 |            203.82 |   2 | 7 | 2 | 2 |
# >> | NegaAlpha | 1..6            |   1615 |      977 |    2 | 3 | 3 |  684 | 33 |  72 |            206.46 |   2 | 7 | 2 | 2 |
# >> | NegaAlpha | 1..7            |   1597 |      961 |    2 | 3 | 3 |  668 | 33 |  72 |            206.35 |   2 | 7 | 2 | 2 |
# >> | NegaAlpha | 1..8            |   1580 |      951 |    2 | 3 | 3 |  659 | 33 |  71 |            204.98 |   2 | 7 | 2 | 2 |
# >> |-----------+-----------------+--------+----------+------+---+---+------+----+-----+-------------------+-----+---+---+---|
