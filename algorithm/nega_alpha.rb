# アルファ・ベータ法 - Wikipedia
# https://ja.wikipedia.org/wiki/%E3%82%A2%E3%83%AB%E3%83%95%E3%82%A1%E3%83%BB%E3%83%99%E3%83%BC%E3%82%BF%E6%B3%95
#
# # ネガアルファ
# def alphabeta(node, depth, alpha, beta)
#   if node.end? || depth == 0
#     return node.score # 手番のプレイヤーから見た評価値
#   end
#
#   node.each do |e|
#     alpha = max(alpha, -alphabeta(e, depth-1, -beta, -alpha))
#     if alpha >= beta
#       break # カット
#     end
#   end
#
#   alpha
# end

require "./nega_max"

class NegaAlpha < NegaMax
  def mini_max(*args)
    nega_alpha(*args, -Float::INFINITY, Float::INFINITY)
  end

  def nega_alpha(turn, depth, depth_max, alpha, beta)
    player = app.player_at(turn)
    children = app.available_points(player)

    if children.empty? || depth >= depth_max
      return [app.evaluate(player), []] # ミニマックスのときとは異なり player から見たスコア
    end

    hands = []
    children.each do |point|
      memento = app.board.dup
      app.put_on(player, point)
      score, before = nega_alpha(turn + 1, depth + 1, depth_max, -beta, -alpha)
      app.board = memento
      score = -score # 相手の一番良い手は自分の一番悪い手としたいので符号を反転する
      if score > alpha # 以上(以下)とするのはスコアが -Infinity であっても有効手としなければ指せるのにパスすることになり反則となってしまう
        hands = [point, *before]
        alpha = score
      end
      if alpha >= beta
        break
      end
    end

    [alpha, hands]
  end
end

if $0 == __FILE__
  NegaAlpha.new.run
end
# >> -------------------- 0: o score:0 読み:[[2, 0], [1, 0]]
# >> ・・○・
# >> ・○○・
# >> ・×○・
# >> ・・・・
# >> -------------------- 1: x score:-3 読み:[[3, 0], [3, 1]]
# >> ・・○×
# >> ・○×・
# >> ・×○・
# >> ・・・・
# >> -------------------- 2: o score:0 読み:[[0, 2], [1, 0]]
# >> ・・○×
# >> ・○×・
# >> ○○○・
# >> ・・・・
# >> -------------------- 3: x score:-3 読み:[[1, 0], [3, 1]]
# >> ・×××
# >> ・○×・
# >> ○○○・
# >> ・・・・
# >> -------------------- 4: o score:-2 読み:[[3, 1], [3, 2]]
# >> ・×××
# >> ・○○○
# >> ○○○・
# >> ・・・・
# >> -------------------- 5: x score:2 読み:[[3, 2]]
# >> ・×××
# >> ・○××
# >> ○○○×
# >> ・・・・
# >> -------------------- 6: o score:-2 読み:[] PASS
# >> ・×××
# >> ・○××
# >> ○○○×
# >> ・・・・
# >> -------------------- 7: x score:9 読み:[[1, 3]]
# >> ・×××
# >> ・×××
# >> ○×××
# >> ・×・・
# >> -------------------- 8: o score:-9 読み:[] PASS
# >> ・×××
# >> ・×××
# >> ○×××
# >> ・×・・
# >> -------------------- 9: x score:9 読み:[] PASS
# >> ・×××
# >> ・×××
# >> ○×××
# >> ・×・・
# >> 両方ともパスしたので終了 : {"o"=>1, "x"=>1}
# >> |---+----|
# >> | x | 10 |
# >> | o | 1  |
# >> |---+----|
