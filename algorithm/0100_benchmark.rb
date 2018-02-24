require 'active_support/core_ext/benchmark'

require "./dirty_minimax"
require "./beauty_minimax"
require "./nega_max"
require "./nega_alpha"

dimension = 4
(4..6).each do |dimension|
  (3..5).each do |depth_max|
    rows = [
      DirtyMinimax,
      BeautyMinimax,
      NegaMax,
      NegaAlpha,
    ].collect do |klass|
      strategy = klass.new
      strategy.params[:silent] = true
      strategy.params[:depth_max] = depth_max
      strategy.params[:dimension] = dimension
      ms = "%8.2f ms" % Benchmark.ms { strategy.run }

      row = {}
      row[:class] = klass.name
      row.update(strategy.app.run_counts)
      row.update(strategy.app.histogram)
      row.update(ms: ms)
    end
    puts
    puts "** 盤面: #{dimension}x#{dimension}, 深さ: #{depth_max}"
    tp rows
  end
end
