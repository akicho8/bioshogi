require 'active_support/core_ext/benchmark'
require './all_algorithms'

dimension = 5
rows = [
  NegaMax,
  NegaAlpha,
  FailSoftNegaAlpha,
  NegaScout,
].flat_map do |model|
  (3..8).collect do |depth_max|
    app = model.new
    app.params[:silent] = true
    app.params[:depth_max_range] = 1..depth_max
    app.params[:time_limit] = 0.05
    app.params[:dimension] = dimension
    app.params[:times] = 2
    start_time = Time.now
    app.run

    row = {}
    row[:model] = model.name
    row[:depth_max_range] = 1..depth_max
    row.update(app.mediator.run_counts)
    row.update(turn: app.current_turn.next)
    row.update(app.mediator.histogram)
    row.update("1手平均(s)": "%.2f" % ((Time.now - start_time) / app.current_turn.next))
    row.update(app.mediator.same_pos.values.group_by(&:itself).transform_values(&:size).sort.to_h.transform_keys { |e| "深度#{e}" })
  end
end
tp rows
# >> |-------------------+-----------------+----------+------+---+---+------------+-------+-------+-------+-------|
# >> | model             | depth_max_range | evaluate | turn | o | x | 1手平均(s) | 深度1 | 深度2 | 深度3 | 深度4 |
# >> |-------------------+-----------------+----------+------+---+---+------------+-------+-------+-------+-------|
# >> | NegaMax           | 1..3            |      328 |    2 | 3 | 3 |       0.05 |   220 |    48 |     4 |       |
# >> | NegaMax           | 1..4            |      327 |    2 | 3 | 3 |       0.05 |   219 |    48 |     4 |       |
# >> | NegaMax           | 1..5            |      314 |    2 | 3 | 3 |       0.05 |   206 |    48 |     4 |       |
# >> | NegaMax           | 1..6            |      294 |    2 | 3 | 3 |       0.05 |   186 |    48 |     4 |       |
# >> | NegaMax           | 1..7            |      318 |    2 | 3 | 3 |       0.05 |   210 |    48 |     4 |       |
# >> | NegaMax           | 1..8            |      298 |    2 | 3 | 3 |       0.05 |   190 |    48 |     4 |       |
# >> | NegaAlpha         | 1..3            |      205 |    2 | 3 | 3 |       0.04 |   151 |    21 |     4 |       |
# >> | NegaAlpha         | 1..4            |      218 |    2 | 3 | 3 |       0.05 |   164 |    21 |     4 |       |
# >> | NegaAlpha         | 1..5            |      211 |    2 | 3 | 3 |       0.05 |   157 |    21 |     4 |       |
# >> | NegaAlpha         | 1..6            |      240 |    2 | 3 | 3 |       0.05 |   182 |    23 |     4 |       |
# >> | NegaAlpha         | 1..7            |      230 |    2 | 3 | 3 |       0.05 |   172 |    23 |     4 |       |
# >> | NegaAlpha         | 1..8            |      254 |    2 | 3 | 3 |       0.05 |   196 |    23 |     4 |       |
# >> | FailSoftNegaAlpha | 1..3            |      271 |    2 | 3 | 3 |       0.05 |   187 |    36 |     4 |       |
# >> | FailSoftNegaAlpha | 1..4            |      294 |    2 | 3 | 3 |       0.05 |   207 |    36 |     5 |       |
# >> | FailSoftNegaAlpha | 1..5            |      256 |    2 | 3 | 3 |       0.05 |   172 |    36 |     4 |       |
# >> | FailSoftNegaAlpha | 1..6            |      261 |    2 | 3 | 3 |       0.05 |   177 |    36 |     4 |       |
# >> | FailSoftNegaAlpha | 1..7            |      284 |    2 | 3 | 3 |       0.05 |   197 |    36 |     5 |       |
# >> | FailSoftNegaAlpha | 1..8            |      237 |    2 | 3 | 3 |       0.05 |   153 |    36 |     4 |       |
# >> | NegaScout         | 1..3            |      157 |    2 | 3 | 3 |       0.05 |   108 |    18 |     3 |     1 |
# >> | NegaScout         | 1..4            |      191 |    2 | 3 | 3 |       0.05 |   129 |    23 |     4 |     1 |
# >> | NegaScout         | 1..5            |      177 |    2 | 3 | 3 |       0.05 |   117 |    22 |     4 |     1 |
# >> | NegaScout         | 1..6            |      180 |    2 | 3 | 3 |       0.05 |   120 |    22 |     4 |     1 |
# >> | NegaScout         | 1..7            |      191 |    2 | 3 | 3 |       0.05 |   129 |    23 |     4 |     1 |
# >> | NegaScout         | 1..8            |      202 |    2 | 3 | 3 |       0.05 |   140 |    23 |     4 |     1 |
# >> |-------------------+-----------------+----------+------+---+---+------------+-------+-------+-------+-------|
