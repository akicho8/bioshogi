require "./beauty_minimax"

class NegaMax < BeautyMinimax
  def mini_max(*args)
    nega_max(*args)
  end

  def nega_max(turn, depth, depth_max)
    player = app.player_at(turn)
    children = app.available_points(player)

    if children.empty? || depth >= depth_max
      return [app.evaluate(player), []] # ミニマックスのときとは異なり player から見たscore
    end

    max = -Float::INFINITY
    hands = []

    children.each do |point|
      memento = app.board.dup
      app.put_on(player, point)
      score, before = nega_max(turn + 1, depth + 1, depth_max)
      app.board = memento
      score = -score # 相手の一番良い手は自分の一番悪い手としたいので符号を反転する
      if score > max
        hands = [point, *before]
        max = score
      end
    end

    [max, hands]
  end
end

if $0 == __FILE__
  NegaMax.new.run
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
# >> -------------------- 3: x score:2 読み:[[1, 0], [3, 1], [3, 2]]
# >> ・×××
# >> ・○×・
# >> ○○○・
# >> ・・・・
# >> -------------------- 4: o score:-2 読み:[[3, 1], [3, 2]]
# >> ・×××
# >> ・○○○
# >> ○○○・
# >> ・・・・
# >> -------------------- 5: x score:4 読み:[[0, 3], [1, 3], [0, 1]]
# >> ・×××
# >> ・○×○
# >> ○×○・
# >> ×・・・
# >> -------------------- 6: o score:-2 読み:[[1, 3], [3, 2]]
# >> ・×××
# >> ・○×○
# >> ○○○・
# >> ×○・・
# >> -------------------- 7: x score:8 読み:[[0, 1], [0, 0], [3, 2]]
# >> ・×××
# >> ×××○
# >> ×○○・
# >> ×○・・
# >> -------------------- 8: o score:-5 読み:[[0, 0], [3, 2], [3, 3]]
# >> ○×××
# >> ×○×○
# >> ×○○・
# >> ×○・・
# >> -------------------- 9: x score:10 読み:[[3, 2], [3, 3], [2, 3]]
# >> ○×××
# >> ×○××
# >> ××××
# >> ×○・・
# >> -------------------- 10: o score:-10 読み:[[3, 3], [2, 3]]
# >> ○×××
# >> ×○××
# >> ××○×
# >> ×○・○
# >> -------------------- 11: x score:10 読み:[[2, 3]]
# >> ○×××
# >> ×○××
# >> ××××
# >> ×××○
# >> |---+----|
# >> | o | 3  |
# >> | x | 13 |
# >> |---+----|
