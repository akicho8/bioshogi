def mini_max(node, depth = 0)
  if depth.zero?
    return evaluate(:black)
  end

  if node.player == :black
    max = -Float::INFINITY
    node.children.each do |node|
      max = [max, mini_max(node, depth - 1)].max
    end
    max
  else
    min = Float::INFINITY
    node.children.each do |node|
      min = [min, mini_max(node, depth - 1)].min
    end
    min
  end
end

def nega_max(node, depth = 0)
  if depth.zero?
    return evaluate(node.player)
  end

  max = -Float::INFINITY
  node.children.each do |node|
    max = [max, -nega_max(node, depth - 1)].max
  end
  max
end

def nega_alpha(node, depth = 0, alpha = -Float::INFINITY, beta = Float::INFINITY)
  if depth.zero?
    return evaluate(node.player)
  end

  node.children.each do |node|
    alpha = [alpha, -nega_alpha(node, depth - 1, -beta, -alpha)].max
    if beta <= alpha
      break
    end
  end
  alpha
end

def fail_soft_nega_alpha(node, depth = 0, alpha = -Float::INFINITY, beta = Float::INFINITY)
  if depth.zero?
    return evaluate(node.player)
  end

  max_v = -Float::INFINITY
  node.children.each do |node|
    max_v = [max_v, -fail_soft_nega_alpha(node, depth - 1, -beta, -[alpha, max_v].max)].max
    if beta <= max_v
      break
    end
  end
  max_v
end

# from wiki
def nega_scout(node, alpha, beta, depth)
  if depth.zero?
    return evaluate(node.player)
  end

  node.move_ordering     # 手の並べ替え

  v = -nega_scout(node.children.first, depth - 1, -beta, -alpha) # 最善候補を通常の窓で探索
  max = v
  if beta <= v
    return v
  end
  if alpha < v
    alpha = v
  end

  children.drop(1).each do |node|
    v = -nega_scout(node, depth - 1, -alpha - 1, -alpha) # Null Window Search
    if beta <= v
      return v
    end
    if alpha < v
      alpha = v
      v = -nega_scout(node, depth - 1, -beta, -alpha) # 通常の窓で再探索
      if beta <= v
        return v
      end
      if alpha < v
        alpha = v
      end
    end
    if max < v
      max = v
    end
  end

  max # 子ノードの最大値を返す (fail-soft)
end

# リスト : ネガスカウト法 (failsoft)

# http://www.geocities.jp/m_hiroi/light/pyalgo25.html
def nega_scout(node, depth, alpha, beta)
  if depth.zero?
    return evaluate(node.player)
  end

  children = node.move_ordering # 良い手順に並べる

  max_v = -Float::INFINITY
  children.each do |node|
    a = [alpha, max_v].max
    v = -nega_scout(node, depth - 1, -(a + 1), -a) # null window search
    if a < v && v < beta
      v = -nega_scout(node, depth - 1, -beta, -v) # 再探索
      if max_v < v              # ネガマックス法 : 大きな値を選ぶ
        max_v = v
      end
    end
    if max_v >= beta            # ネガアルファ法
      break
    end
  end
  max_v
end
