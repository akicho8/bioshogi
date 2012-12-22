# -*- coding: utf-8 -*-

require "active_support/core_ext/string"
require "active_support/configurable"
require "pry-debugger"

require "rain_table"

module Bushido
  include ActiveSupport::Configurable
  config_accessor :format
  config.format = :basic

  class BushidoError < StandardError; end

  class MustNotHappen < BushidoError; end
  class UnconfirmedObject < BushidoError; end
  class MovableSoldierNotFound < BushidoError; end
  class AmbiguousFormatError < BushidoError; end
  class SyntaxError < BushidoError; end
  class PointSyntaxError < BushidoError; end
  class UnknownPositionName < BushidoError; end
  class PieceNotFound < BushidoError; end
  class PieceAlredyExist < BushidoError; end
  class SamePlayerSoldierOverwrideError < BushidoError; end
  class NotPromotable < BushidoError; end
  class PromotedPiecePutOnError < BushidoError; end
  class AlredyPromoted < BushidoError; end
  class NotFoundOnBoard < BushidoError; end
  class PromotedPieceToNormalPiece < BushidoError; end
  class NotPutInPlaceNotBeMoved < BushidoError; end
  class DoublePawn < BushidoError; end
  class BeforePointNotFound < BushidoError; end

  class Vector < Array
    def initialize(arg)
      super()
      replace(arg)
    end

    def reverse
      x, y = self
      self.class.new([-x, -y])
    end
  end
end

require_relative "bushido/version"
require_relative "bushido/position"
require_relative "bushido/point"
require_relative "bushido/piece"
require_relative "bushido/board"
require_relative "bushido/soldier"
require_relative "bushido/player"
require_relative "bushido/frame"

require_relative "bushido/kif_format"

module Bushido
  Board.send(:include, KifFormat::Board)
  Soldier.send(:include, KifFormat::Soldier)
end

module Bushido
  if $0 == __FILE__
    frame = Frame.new
    frame.players << Player.create2(:black, frame.board)
    frame.players << Player.create2(:white, frame.board)
    puts frame.board

    # @board = Board.new
    # @players = []
    # @players << Player.create2(:black, @board)
    # @players << Player.create2(:white, @board)
    # @players.each(&:setup)
    # @players[0].execute("7六歩")
    # puts @board

    # @players[0].move_to("7七", "7六")
    # puts @board
    # @players[1].move_to("3三", "3四")
    # puts @board
    # @players[0].move_to("8八", "2二")
    # puts @board
  end
end
