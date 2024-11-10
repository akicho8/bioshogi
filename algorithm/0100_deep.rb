require 'active_support/core_ext/benchmark'
require './all_algorithms'

dimension_size = 5
rows = [
  NegaMax,
  NegaAlpha,
  NegaAlphaFs,
  BuggyNegaScout,
  NegaScout,
].flat_map do |model|
  (3..8).collect do |depth_max|
    app = model.new
    app.params[:silent] = true
    app.params[:depth_max_range] = 1..depth_max
    app.params[:time_limit] = 0.05
    app.params[:dimension_size] = dimension_size
    app.params[:times] = 2
    start_time = Time.now
    app.run

    row = {}
    row[:model] = model.name
    row[:depth_max_range] = 1..depth_max
    row.update(app.container.run_counts)
    row.update(turn: app.current_turn.next)
    row.update(app.container.histogram)
    row.update("1手平均(s)": "%.2f" % ((Time.now - start_time) / app.current_turn.next))
    row.update(app.container.same_pos.values.group_by(&:itself).transform_values(&:size).sort.to_h.transform_keys { |e| "深度#{e}" })
  end
end
tp rows
# >> |----------------+-----------------+----------+------+---+---+------------+-------+-------+-------+-------|
# >> | model          | depth_max_range | evaluate | turn | o | x | 1手平均(s) | 深度1 | 深度2 | 深度3 | 深度4 |
# >> |----------------+-----------------+----------+------+---+---+------------+-------+-------+-------+-------|
# >> | NegaMax        | 1..3            |      282 |    2 | 3 | 3 |       0.05 |   174 |    48 |     4 |       |
# >> | NegaMax        | 1..4            |      288 |    2 | 3 | 3 |       0.05 |   180 |    48 |     4 |       |
# >> | NegaMax        | 1..5            |      280 |    2 | 3 | 3 |       0.05 |   172 |    48 |     4 |       |
# >> | NegaMax        | 1..6            |      277 |    2 | 3 | 3 |       0.05 |   169 |    48 |     4 |       |
# >> | NegaMax        | 1..7            |      272 |    2 | 3 | 3 |       0.05 |   164 |    48 |     4 |       |
# >> | NegaMax        | 1..8            |      271 |    2 | 3 | 3 |       0.05 |   163 |    48 |     4 |       |
# >> | NegaAlpha      | 1..3            |      149 |    2 | 3 | 3 |       0.05 |    96 |    22 |     3 |       |
# >> | NegaAlpha      | 1..4            |      194 |    2 | 3 | 3 |       0.05 |   141 |    22 |     3 |       |
# >> | NegaAlpha      | 1..5            |      203 |    2 | 3 | 3 |       0.05 |   149 |    21 |     4 |       |
# >> | NegaAlpha      | 1..6            |      198 |    2 | 3 | 3 |       0.05 |   145 |    22 |     3 |       |
# >> | NegaAlpha      | 1..7            |      203 |    2 | 3 | 3 |       0.05 |   150 |    22 |     3 |       |
# >> | NegaAlpha      | 1..8            |      162 |    2 | 3 | 3 |       0.05 |   109 |    22 |     3 |       |
# >> | NegaAlphaFs    | 1..3            |      191 |    2 | 3 | 3 |       0.05 |   107 |    36 |     4 |       |
# >> | NegaAlphaFs    | 1..4            |      228 |    2 | 3 | 3 |       0.05 |   144 |    36 |     4 |       |
# >> | NegaAlphaFs    | 1..5            |      225 |    2 | 3 | 3 |       0.05 |   141 |    36 |     4 |       |
# >> | NegaAlphaFs    | 1..6            |      213 |    2 | 3 | 3 |       0.05 |   129 |    36 |     4 |       |
# >> | NegaAlphaFs    | 1..7            |      190 |    2 | 3 | 3 |       0.05 |   110 |    37 |     2 |       |
# >> | NegaAlphaFs    | 1..8            |      228 |    2 | 3 | 3 |       0.05 |   144 |    36 |     4 |       |
# >> | BuggyNegaScout | 1..3            |      100 |    2 | 3 | 3 |       0.05 |    66 |    12 |     2 |     1 |
# >> | BuggyNegaScout | 1..4            |      102 |    2 | 3 | 3 |       0.05 |    68 |    12 |     2 |     1 |
# >> | BuggyNegaScout | 1..5            |       93 |    2 | 3 | 3 |       0.05 |    59 |    12 |     2 |     1 |
# >> | BuggyNegaScout | 1..6            |       83 |    2 | 3 | 3 |       0.05 |    49 |    12 |     2 |     1 |
# >> | BuggyNegaScout | 1..7            |       98 |    2 | 3 | 3 |       0.05 |    64 |    12 |     2 |     1 |
# >> | BuggyNegaScout | 1..8            |       99 |    2 | 3 | 3 |       0.05 |    65 |    12 |     2 |     1 |
# >> | NegaScout      | 1..3            |       78 |    2 | 3 | 3 |       0.05 |    61 |     7 |     1 |       |
# >> | NegaScout      | 1..4            |       74 |    2 | 3 | 3 |       0.05 |    57 |     7 |     1 |       |
# >> | NegaScout      | 1..5            |       79 |    2 | 3 | 3 |       0.05 |    62 |     7 |     1 |       |
# >> | NegaScout      | 1..6            |       82 |    2 | 3 | 3 |       0.05 |    65 |     7 |     1 |       |
# >> | NegaScout      | 1..7            |       81 |    2 | 3 | 3 |       0.05 |    64 |     7 |     1 |       |
# >> | NegaScout      | 1..8            |       80 |    2 | 3 | 3 |       0.05 |    63 |     7 |     1 |       |
# >> |----------------+-----------------+----------+------+---+---+------------+-------+-------+-------+-------|
