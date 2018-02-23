# ミニマックスの綺麗な実装

require "./dirty_minimax"

class BeautyMinimax < DirtyMinimax
  def mini_max(turn, depth, depth_max)
    player = app.player_at(turn)
    children = app.available_points(player)

    if children.empty? || depth >= depth_max
      return [app.evaluate_for_o, []] # 常に先手からの評価値
    end

    if turn.even?
      max = -Float::INFINITY
    else
      max = Float::INFINITY
    end

    hands = []
    children.each do |point|
      app.put_on(player, point) do
        score, before = mini_max(turn + 1, depth + 1, depth_max)
        if turn.even?
          flag = score > max
        else
          flag = score < max
        end
        if flag
          hands = [point, *before]
          max = score
        end
      end
    end

    [max, hands]
  end
end

if $0 == __FILE__
  BeautyMinimax.new.run
end
# >> -------------------- 0: o score:3 読み:[[2, 0], [3, 0], [3, 1]]
# >> ・・○・
# >> ・○○・
# >> ・×○・
# >> ・・・・
# >> -------------------- 1: x score:0 読み:[[3, 0], [0, 2], [1, 0]]
# >> ・・○×
# >> ・○×・
# >> ・×○・
# >> ・・・・
# >> -------------------- 2: o score:3 読み:[[0, 2], [1, 0], [3, 1]]
# >> ・・○×
# >> ・○×・
# >> ○○○・
# >> ・・・・
# >> -------------------- 3: x score:-2 読み:[[1, 0], [3, 1], [3, 2]]
# >> ・×××
# >> ・○×・
# >> ○○○・
# >> ・・・・
# >> -------------------- 4: o score:-2 読み:[[3, 1], [3, 2]]
# >> ・×××
# >> ・○○○
# >> ○○○・
# >> ・・・・
# >> -------------------- 5: x score:-4 読み:[[0, 3], [1, 3], [0, 1]]
# >> ・×××
# >> ・○×○
# >> ○×○・
# >> ×・・・
# >> -------------------- 6: o score:-2 読み:[[1, 3], [3, 2]]
# >> ・×××
# >> ・○×○
# >> ○○○・
# >> ×○・・
# >> -------------------- 7: x score:-8 読み:[[0, 1], [0, 0], [3, 2]]
# >> ・×××
# >> ×××○
# >> ×○○・
# >> ×○・・
# >> -------------------- 8: o score:-5 読み:[[0, 0], [3, 2], [3, 3]]
# >> ○×××
# >> ×○×○
# >> ×○○・
# >> ×○・・
# >> -------------------- 9: x score:-10 読み:[[3, 2], [3, 3], [2, 3]]
# >> ○×××
# >> ×○××
# >> ××××
# >> ×○・・
# >> -------------------- 10: o score:-10 読み:[[3, 3], [2, 3]]
# >> ○×××
# >> ×○××
# >> ××○×
# >> ×○・○
# >> -------------------- 11: x score:-10 読み:[[2, 3]]
# >> ○×××
# >> ×○××
# >> ××××
# >> ×××○
# >> |---+----|
# >> | o | 3  |
# >> | x | 13 |
# >> |---+----|
