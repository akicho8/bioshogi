require 'active_support/core_ext/benchmark'
require "./all_algorithms"

(5..5).each do |dimension|
  (0..4).each do |depth_max|
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
      row.update(app.mediator.run_counts)
      row.update(app.mediator.histogram)
      row.update(sec: "%.2f" % (Time.now - start_time))
    end
    puts
    puts "** 盤面: #{dimension}x#{dimension}, 深さ: #{depth_max}"
    tp rows
  end
end
# >> 
# >> ** 盤面: 4x4, 深さ: 0
# >> |----------------+----------+---+----+------|
# >> | model          | evaluate | o | x  | sec  |
# >> |----------------+----------+---+----+------|
# >> | DirtyMinimax   |       31 | 5 | 11 | 0.01 |
# >> | Minimax        |       31 | 5 | 11 | 0.01 |
# >> | NegaMax        |       31 | 5 | 11 | 0.01 |
# >> | NegaAlpha      |       31 | 5 | 11 | 0.01 |
# >> | NegaAlphaFs    |       31 | 5 | 11 | 0.01 |
# >> | BuggyNegaScout |       31 | 5 | 11 | 0.01 |
# >> | NegaScout      |       31 | 5 | 11 | 0.01 |
# >> |----------------+----------+---+----+------|
# >> 
# >> ** 盤面: 4x4, 深さ: 1
# >> |----------------+----------+---+----+------|
# >> | model          | evaluate | o | x  | sec  |
# >> |----------------+----------+---+----+------|
# >> | DirtyMinimax   |       57 | 1 | 10 | 0.02 |
# >> | Minimax        |       57 | 1 | 10 | 0.02 |
# >> | NegaMax        |       57 | 1 | 10 | 0.02 |
# >> | NegaAlpha      |       57 | 1 | 10 | 0.02 |
# >> | NegaAlphaFs    |       57 | 1 | 10 | 0.02 |
# >> | BuggyNegaScout |       78 | 1 | 10 | 0.04 |
# >> | NegaScout      |       57 | 1 | 10 | 0.03 |
# >> |----------------+----------+---+----+------|
# >> 
# >> ** 盤面: 4x4, 深さ: 2
# >> |----------------+----------+---+----+------|
# >> | model          | evaluate | o | x  | sec  |
# >> |----------------+----------+---+----+------|
# >> | DirtyMinimax   |      184 | 8 |  8 | 0.05 |
# >> | Minimax        |      184 | 8 |  8 | 0.05 |
# >> | NegaMax        |      184 | 8 |  8 | 0.05 |
# >> | NegaAlpha      |      128 | 8 |  8 | 0.04 |
# >> | NegaAlphaFs    |      184 | 8 |  8 | 0.05 |
# >> | BuggyNegaScout |      220 | 5 | 11 | 0.12 |
# >> | NegaScout      |      126 | 8 |  8 | 0.08 |
# >> |----------------+----------+---+----+------|
# >> 
# >> ** 盤面: 4x4, 深さ: 3
# >> |----------------+----------+---+----+------|
# >> | model          | evaluate | o | x  | sec  |
# >> |----------------+----------+---+----+------|
# >> | DirtyMinimax   |      461 | 1 | 10 | 0.14 |
# >> | Minimax        |      461 | 1 | 10 | 0.13 |
# >> | NegaMax        |      461 | 1 | 10 | 0.12 |
# >> | NegaAlpha      |      244 | 1 | 10 | 0.09 |
# >> | NegaAlphaFs    |      362 | 1 | 10 | 0.12 |
# >> | BuggyNegaScout |      219 | 6 | 10 | 0.21 |
# >> | NegaScout      |      231 | 1 | 10 | 0.18 |
# >> |----------------+----------+---+----+------|
# >> 
# >> ** 盤面: 4x4, 深さ: 4
# >> |----------------+----------+---+----+------|
# >> | model          | evaluate | o | x  | sec  |
# >> |----------------+----------+---+----+------|
# >> | DirtyMinimax   |     1538 | 2 | 13 | 0.41 |
# >> | Minimax        |     1538 | 2 | 13 | 0.40 |
# >> | NegaMax        |     1538 | 2 | 13 | 0.42 |
# >> | NegaAlpha      |      410 | 2 | 13 | 0.21 |
# >> | NegaAlphaFs    |      808 | 2 | 13 | 0.27 |
# >> | BuggyNegaScout |      525 | 6 | 10 | 0.37 |
# >> | NegaScout      |      428 | 2 | 13 | 0.34 |
# >> |----------------+----------+---+----+------|
# >> 
# >> ** 盤面: 4x4, 深さ: 5
# >> |----------------+----------+---+----+------|
# >> | model          | evaluate | o | x  | sec  |
# >> |----------------+----------+---+----+------|
# >> | DirtyMinimax   |     3865 | 2 | 11 | 1.05 |
# >> | Minimax        |     3865 | 2 | 11 | 1.05 |
# >> | NegaMax        |     3865 | 2 | 11 | 1.02 |
# >> | NegaAlpha      |      810 | 2 | 11 | 0.37 |
# >> | NegaAlphaFs    |     1414 | 2 | 11 | 0.53 |
# >> | BuggyNegaScout |      525 | 6 | 10 | 0.52 |
# >> | NegaScout      |      810 | 2 | 11 | 0.61 |
# >> |----------------+----------+---+----+------|
# >> 
# >> ** 盤面: 4x4, 深さ: 6
# >> |----------------+----------+---+----+------|
# >> | model          | evaluate | o | x  | sec  |
# >> |----------------+----------+---+----+------|
# >> | DirtyMinimax   |     8880 | 2 | 14 | 2.56 |
# >> | Minimax        |     8880 | 2 | 14 | 2.53 |
# >> | NegaMax        |     8880 | 2 | 14 | 2.52 |
# >> | NegaAlpha      |     1285 | 2 | 14 | 0.62 |
# >> | NegaAlphaFs    |     2562 | 2 | 14 | 1.04 |
# >> | BuggyNegaScout |     1201 | 6 | 10 | 0.86 |
# >> | NegaScout      |     1272 | 2 | 14 | 1.04 |
# >> |----------------+----------+---+----+------|
