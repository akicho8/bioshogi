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

def nega_alpha_fs(node, depth = 0, alpha = -Float::INFINITY, beta = Float::INFINITY)
  if depth.zero?
    return evaluate(node.player)
  end

  max_v = -Float::INFINITY
  node.children.each do |node|
    max_v = [max_v, -nega_alpha_fs(node, depth - 1, -beta, -[alpha, max_v].max)].max
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

  v = -buggy_nega_scout(node.children.first, depth - 1, -beta, -alpha) # 最善候補を通常の窓で探索
  max = v
  if beta <= v
    return v
  end
  if alpha < v
    alpha = v
  end

  children.drop(1).each do |node|
    v = -buggy_nega_scout(node, depth - 1, -alpha - 1, -alpha) # Null Window Search
    if beta <= v
      return v
    end
    if alpha < v
      alpha = v
      v = -buggy_nega_scout(node, depth - 1, -beta, -alpha) # 通常の窓で再探索
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
def buggy_nega_scout(node, depth, alpha, beta)
  if depth.zero?
    return evaluate(node.player)
  end

  children = node.move_ordering # 良い手順に並べる

  max_v = -Float::INFINITY
  children.each do |node|
    a = [alpha, max_v].max
    v = -buggy_nega_scout(node, depth - 1, -(a + 1), -a) # null window search
    if a < v && v < beta
      v = -buggy_nega_scout(node, depth - 1, -beta, -v) # 再探索
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

# 置換付

def nega_alpha2(node, depth, alpha, beta)
  if depth.zero?
    return evaluate(node.player)
  end

  # 現在の局面を置換表から検索して[上限, 下限]を取り出し; # 存在しなければ追加
  # 以下、「上限」「下限」とはこの置換表から取り出した値のことをいう
  node_hash = node.hash
  if m = @memo[node_hash]
    if m.end <= alpha
      return m.end # alpha値を超えようがないので探索しても無駄
    end
    if m.begin >= beta # beta値を必ず超えてしまうので探索しても無駄
      return m.begin
    end
    if m.begin == m.end
      return m.end # 既に真の値がわかっているので返す
    end

    # alpha-beta windowをなるべく狭くして効率up
    alpha = [alpha, m.begin].max
    beta  = [beta, m.end].min
  end

  max_v = -Float::INFINITY # このノードで出た最大値
  a = alpha

  children = node.move_ordering # 良い手順に並べる

  children.each do |node|
    v = -nega_alpha2(node, depth - 1, -beta, -a)
    if v >= beta # beta cut
      @memo[node_hash] = (v...Float::INFINITY) # v...Float::INFINITY # 置換表に[v, +∞) を追加 # 真の評価値は[v, +∞ のどこか
      return v
    end
    if max_v < v
      max_v = v
      if a < v
        a = v
      end
    end
  end

  if max_v > alpha
    @memo[node_hash] = (max_v..max_v) # 真の評価値はmax_vと判明した
  else
    @memo[node_hash] = (-Float::INFINITY..max_v) # 真の評価値は (-∞, max_v]のどこか
  end

  max_v
end
