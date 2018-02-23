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
  strategy.params[:depth_max] = 4
  strategy.params[:dimension] = 5
  strategy.run

  row = {}
  row[:class] = klass.name
  row.update(strategy.app.run_counts)
  row.merge(strategy.app.histogram)
end
tp rows
# >> |---------------+--------+----+---|
# >> | class         | put_on | o  | x |
# >> |---------------+--------+----+---|
# >> | DirtyMinimax  |   5008 | 17 | 4 |
# >> | BeautyMinimax |   5008 | 17 | 4 |
# >> | NegaMax       |   5008 | 17 | 4 |
# >> | NegaAlpha     |   1296 | 17 | 4 |
# >> |---------------+--------+----+---|
