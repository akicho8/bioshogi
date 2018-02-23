require "./dirty_minimax"
require "./beauty_minimax"
require "./nega_max"
require "./nega_alpha"

rows = [
  DirtyMinimax,
  BeautyMinimax,
  NegaMax,
  NegaAlpha,
].collect do |klass|
  strategy = klass.new
  strategy.params[:silent] = true
  strategy.params[:depth_max] = 7
  strategy.params[:dimension] = 4
  strategy.run

  row = {}
  row[:class] = klass.name
  row.update(strategy.app.run_counts)
  row.merge(strategy.app.histogram)
end
tp rows
# >> |---------------+--------+----+---|
# >> | class         | put_on | x  | o |
# >> |---------------+--------+----+---|
# >> | DirtyMinimax  |  14245 | 11 | 5 |
# >> | BeautyMinimax |  14245 | 11 | 5 |
# >> | NegaMax       |  14245 | 11 | 5 |
# >> | NegaAlpha     |   2069 | 11 | 5 |
# >> |---------------+--------+----+---|
