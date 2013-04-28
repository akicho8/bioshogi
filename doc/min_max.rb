# -*- coding: utf-8 -*-
# min max アルゴリズム

class Node
  attr_accessor :type, :value, :nodes
  def initialize(type, value)
    @type = type
    @value = value
    @nodes = []
  end
end

def min_max(node, depth)
  if depth == 0
    return node.value
  end

  nodes = node.nodes

  if nodes.empty?
    return node.value
  end

  if "nodeが自分の局面"
    max = -9999
    nodes.each{|node|
      score = min_max(node, depth - 1)
      if max < score
        max = score
      end
    }
  elsif "nodeが相手の局面"
    min = 9999
    nodes.each{|node|
      score = min_max(node, depth - 1)
      if min > score
        min = score
      end
    }
    return min
  end
end

n0 = Node.new(:b, 100)
n0.nodes << Node.new(:w, 50)

min_max()
