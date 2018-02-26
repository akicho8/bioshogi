require 'active_support/core_ext/benchmark'
require "./all_algorithms"

(5..5).each do |dimension|
  (4..6).each do |depth_max|
    rows = [
      # DirtyMinimax,
      # BeautyMinimax,
      # NegaMax,
      NegaAlpha,
      # FailSoftNegaAlpha,
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
# >> ** 盤面: 5x5, 深さ: 4
# >> |-----------+----------+----+----+------|
# >> | model     | evaluate | o  | x  | sec  |
# >> |-----------+----------+----+----+------|
# >> | NegaAlpha |     1829 |  0 | 21 | 0.71 |
# >> | NegaScout |     3089 | 11 | 14 | 1.90 |
# >> |-----------+----------+----+----+------|
# >> 
# >> ** 盤面: 5x5, 深さ: 5
# >> |-----------+----------+----+----+------|
# >> | model     | evaluate | o  | x  | sec  |
# >> |-----------+----------+----+----+------|
# >> | NegaAlpha |     5956 |  0 | 23 | 2.37 |
# >> | NegaScout |     3107 | 11 | 14 | 2.81 |
# >> |-----------+----------+----+----+------|
# >> 
# >> ** 盤面: 5x5, 深さ: 6
# >> |-----------+----------+----+----+-------|
# >> | model     | evaluate | o  | x  | sec   |
# >> |-----------+----------+----+----+-------|
# >> | NegaAlpha |    35320 | 21 |  4 | 13.07 |
# >> | NegaScout |    11110 | 11 | 14 |  6.54 |
# >> |-----------+----------+----+----+-------|
