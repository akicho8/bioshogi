# -*- coding: utf-8 -*-
# 設計の改善案

class Board
  attr_accessor :surface
  def initialize(mediator)
    @mediator = mediator
    @surface = {}
  end
end

class Player
  attr_accessor :name, :mediator
  def initialize(mediator, name)
    @mediator = mediator
    @name = name
  end
end

class Mediator
  attr_accessor :players, :board
  def initialize
    @players = []
    @players << Player.new(self)
    @players << Player.new(self)
    @board = Board.new(self)
  end
end

p Mediator.new
