# ミニマックス・ネガマックス・ネガアルファ法の擬似コードまとめ

# ミニマックス法

```ruby
def mini_max(node, depth_max, depth = 0)
  if depth >= depth_max
    return evaluate(:black)
  end

  if node.player == :black
    max = -Float::INFINITY
    node.children.each do |node|
      max = [max, mini_max(node, depth_max, depth.next)].max
    end
    max
  else
    min = Float::INFINITY
    node.children.each do |node|
      min = [min, mini_max(node, depth_max, depth.next)].min
    end
    min
  end
end
```

# ネガマックス法

```ruby
def nega_max(node, depth_max, depth = 0)
  if depth >= depth_max
    return evaluate(node.player)
  end

  max = -Float::INFINITY
  node.children.each do |node|
    max = [max, -nega_max(node, depth_max, depth.next)].max
  end
  max
end
```

# ネガアルファ法

```ruby
def nega_alpha(node, depth_max, depth = 0, alpha = -Float::INFINITY, beta = Float::INFINITY)
  if depth >= depth_max
    return evaluate(node.player)
  end

  node.children.each do |node|
    alpha = [alpha, -nega_alpha(node, depth_max, depth.next, -beta, -alpha)].max
    if alpha >= beta
      break
    end
  end
  alpha
end
```
