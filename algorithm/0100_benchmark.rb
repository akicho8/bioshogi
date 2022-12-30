require 'active_support/core_ext/benchmark'
require "./all_algorithms"

(4..4).each do |dimension|
  (4..4).each do |depth_max|
    rows = [
      DirtyMinimax,
      Minimax,
      NegaMax,
      NegaAlpha,
      NegaAlphaFs,
      BuggyNegaScout,
      NegaScout,
    ].collect do |klass|
      app = klass.new
      app.params[:silent] = true
      app.params[:depth_max] = depth_max
      app.params[:dimension] = dimension
      start_time = Time.now
      app.run

      row = {}
      row[:model] = klass.name
      row.update(app.container.run_counts)
      row.update(app.container.histogram)
      row.update(sec: "%.2f" % (Time.now - start_time))
    end
    puts
    puts "** 盤面: #{dimension}x#{dimension}, 深さ: #{depth_max}"
    tp rows
  end
end
# >> 
# >> ** 盤面: 4x4, 深さ: 4
# >> |----------------+----------+---+----+------|
# >> | model          | evaluate | o | x  | sec  |
# >> |----------------+----------+---+----+------|
# >> | DirtyMinimax   |     1538 | 2 | 13 | 0.34 |
# >> | Minimax        |     1538 | 2 | 13 | 0.33 |
# >> | NegaMax        |     1538 | 2 | 13 | 0.33 |
# >> | NegaAlpha      |      410 | 2 | 13 | 0.16 |
# >> | NegaAlphaFs    |      808 | 2 | 13 | 0.23 |
# >> | BuggyNegaScout |      525 | 6 | 10 | 0.30 |
# >> | NegaScout      |      428 | 2 | 13 | 0.28 |
# >> |----------------+----------+---+----+------|
