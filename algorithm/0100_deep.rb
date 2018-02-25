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
    app = model.new
    app.params[:silent] = true
    app.params[:depth_max_range] = 1..depth_max
    app.params[:time_limit] = 0.05
    app.params[:dimension] = dimension
    app.params[:times] = 2
    ms = Benchmark.ms { app.run }
    row = {}
    row[:model] = model.name
    row[:depth_max_range] = 1..depth_max
    row.update(app.mediator.run_counts)
    row.update(turn: app.current_turn.next)
    row.update(app.mediator.histogram)
    row.update(app.mediator.same_pos.values.group_by(&:itself).transform_values(&:size))
    row.update("指し手1手平均(ms)": "%.2f" % (ms / app.current_turn.next))
  end
end
tp rows
# >> |-----------+-----------------+--------+----------+------+---+---+------+----+-----+-------------------+-----+---+---+---|
# >> | model     | depth_max_range | put_on | evaluate | turn | o | x |    1 |  3 |   2 | 指し手1手平均(ms) | TLE | 4 | 5 | 6 |
# >> |-----------+-----------------+--------+----------+------+---+---+------+----+-----+-------------------+-----+---+---+---|
# >> | NegaMax   | 1..3            |    597 |      441 |    2 | 3 | 3 |  321 |  6 |  51 |             58.54 |     |   |   |   |
# >> | NegaMax   | 1..4            |   1966 |     1484 |    2 | 3 | 3 |  995 | 19 | 202 |            195.72 |   2 | 3 | 3 |   |
# >> | NegaMax   | 1..5            |   2088 |     1578 |    2 | 3 | 3 | 1086 | 19 | 204 |            205.87 |   2 | 3 | 3 |   |
# >> | NegaMax   | 1..6            |   1991 |     1503 |    2 | 3 | 3 | 1026 | 18 | 201 |            201.69 |   2 | 4 | 1 |   |
# >> | NegaMax   | 1..7            |   1957 |     1476 |    2 | 3 | 3 |  999 | 18 | 201 |            205.50 |   2 | 4 | 1 |   |
# >> | NegaMax   | 1..8            |   2095 |     1584 |    2 | 3 | 3 | 1086 | 19 | 207 |            204.38 |   2 | 3 | 3 |   |
# >> | NegaAlpha | 1..3            |    336 |      216 |    2 | 3 | 3 |  162 |  4 |  21 |             48.48 |     |   |   |   |
# >> | NegaAlpha | 1..4            |    721 |      447 |    2 | 3 | 3 |  342 | 11 |  34 |            104.13 |   1 | 1 |   |   |
# >> | NegaAlpha | 1..5            |   1499 |      897 |    2 | 3 | 3 |  606 | 33 |  71 |            200.61 |   2 | 7 | 2 | 2 |
# >> | NegaAlpha | 1..6            |   1411 |      841 |    2 | 3 | 3 |  556 | 33 |  68 |            201.98 |   2 | 7 | 2 | 2 |
# >> | NegaAlpha | 1..7            |    922 |      568 |    2 | 3 | 3 |  386 | 13 |  63 |            203.88 |   2 | 4 |   |   |
# >> | NegaAlpha | 1..8            |   1339 |      798 |    2 | 3 | 3 |  521 | 29 |  79 |            203.92 |   2 | 3 | 4 |   |
# >> |-----------+-----------------+--------+----------+------+---+---+------+----+-----+-------------------+-----+---+---+---|
