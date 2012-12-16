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
  class NotFoundOnField < BushidoError; end
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

  class Frame
    attr_accessor :players, :field

    def self.setup
      new.tap do |o|
        o.player_join(Player.create1(:black))
        o.player_join(Player.create1(:white))
      end
    end

    def initialize
      @field = Field.new
      @players = []
    end

    def player_join(player)
      @players << player
      player.frame = self
      player.field = @field
    end

    def attach
      # # ここで設定するのおかしくね？
      # @players.each{|player|player.frame = self}
    end

    def piece_discard
      @players.collect(&:piece_discard)
    end
  end
end

require_relative "bushido/version"
require_relative "bushido/position"
require_relative "bushido/point"
require_relative "bushido/piece"
require_relative "bushido/field"
require_relative "bushido/soldier"
require_relative "bushido/player"

module Bushido
  if $0 == __FILE__
    frame = Frame.new
    frame.players << Player.create3(:black, frame.field, :black)
    frame.players << Player.create3(:white, frame.field, :white)
    frame.attach
    puts frame.field

    # @field = Field.new
    # @players = []
    # @players << Player.create3(:black, @field, :black)
    # @players << Player.create3(:white, @field, :white)
    # @players.each(&:setup)
    # @players[0].execute("7六歩")
    # puts @field

    # @players[0].move_to("7七", "7六")
    # puts @field
    # @players[1].move_to("3三", "3四")
    # puts @field
    # @players[0].move_to("8八", "2二")
    # puts @field
  end
end
