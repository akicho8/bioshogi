# 考え方

[10, 20, 15, 40].max                   # => 40

# となっているとき 20 のあと 15 を見る必要がないことがわかる
# 言い変えると 15 を返す処理 x を実行する必要がない

def x
  15
end

[10, 20, x, 40].max                   # => 40
[10, 20, x, 40].max                   # => 40

# なので 20 が最大値のとき alpha = 20 として
@alpha = 20

def x
  [15, 25].find_all { |e| e >= @alpha }.min # min の前に 15 を求める処理を除外できる
end

[10, 20, x, 40]                 # => [10, 20, 25, 40]
[10, 20, x, 40].max             # => 40

# 仮コード

def alphabeta(node, depth, alpha, beta)
  if node.end? or depth == 0
    return "score"
  end
  if turn.even?
    node.each do |e|
      alpha = max(alpha, alphabeta(e, depth-1, alpha, beta))
      if alpha >= beta
        break # betaカット
      end
    end
    alpha
  else
    node.each do |e|
      beta = min(beta, alphabeta(e, depth-1, alpha, beta))
      if alpha >= beta
        break # alphaカット
      end
    end
    beta
  end
end

# ネガアルファ版

def alphabeta(node, depth, alpha, beta)
  if node.end? || depth == 0
    return "score"
  end

  node.each do |e|
    alpha = max(alpha, -alphabeta(e, depth-1, -beta, -alpha))
    if alpha >= beta
      return alpha # カット
    end
  end

  alpha
end
