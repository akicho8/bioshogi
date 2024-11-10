# 単純に実装すると手がわからない

require "./reversi_app"

class SimpleMinimax
  attr_accessor :container

  def run
    @container = ReversiApp.new(dimension_size: 6)
    depth_max = 3

    turn = 0
    score = mini_max(turn, 0, depth_max)
    score                       # => 3
    # 手は？
  end

  def mini_max(turn, depth, depth_max)
    player = container.player_at(turn)
    children = container.available_places(player)

    if depth_max <= depth
      return container.evaluate(:o) # 常に先手からの評価値
    end

    # 合法手がないので相手に手番を渡す
    if children.empty?
      return mini_max(turn + 1, depth + 1, depth_max)
    end

    if turn.even?
      # 自分が自分にとってもっとも有利な手を探す
      max = -Float::INFINITY
      children.each do |vec|
        container.place_on(player, vec) do
          score = mini_max(turn + 1, depth + 1, depth_max)
          if score > max
            max = score
          end
        end
      end
      max
    else
      # 相手が自分にとってもっとも不利な手を探す
      min = Float::INFINITY
      children.each do |vec|
        container.place_on(player, vec) do
          score = mini_max(turn + 1, depth + 1, depth_max)
          if score < min
            min = score
          end
        end
      end
      min
    end
  end
end

if $0 == __FILE__
  SimpleMinimax.new.run
end
