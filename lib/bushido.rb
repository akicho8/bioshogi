# -*- coding: utf-8 -*-

require "active_support/core_ext/string"
require "active_support/configurable"
require "active_support/core_ext/class/attribute_accessors"
# require "pry-debugger" # これを有効にすると pry + rcodetools の環境でバックトレースがでまくる

require "rain_table"

module Bushido
  include ActiveSupport::Configurable
  config_accessor :format
  config.format = :basic

  WHITE_SPACE = /[ #{[0x3000].pack('U')}]/
  SEPARATOR = " "

  class BushidoError < StandardError; end

  class MustNotHappen < BushidoError; end
  class UnconfirmedObject < BushidoError; end
  class MovableSoldierNotFound < BushidoError; end
  class AmbiguousFormatError < BushidoError; end
  class SoldierEmpty < BushidoError; end
  class PieceNotFound < BushidoError; end
  class PieceAlredyExist < BushidoError; end
  class AlredyPromoted < BushidoError; end
  class NotPutInPlaceNotBeMoved < BushidoError; end
  class BeforePointNotFound < BushidoError; end
  class FileFormatError < BushidoError; end

  # 構文エラー
  class SyntaxError < BushidoError; end
  class IllegibleFormat < SyntaxError; end
  class RuleError < SyntaxError; end
  class HistroyStackEmpty < SyntaxError; end

  # 構文エラーから発生する継続が難しいエラー
  class PositionSyntaxError < SyntaxError; end
  class PointSyntaxError < SyntaxError; end

  # 別に問題ないけど将棋のルール上エラーとするもの
  class DoublePawn < RuleError; end
  class NoPromotablePiece < RuleError; end
  class NotFoundOnBoard < RuleError; end
  class NotPromotable < RuleError; end
  class PromotedPiecePutOnError < RuleError; end
  class PromotedPieceToNormalPiece < RuleError; end
  class SamePlayerSoldierOverwrideError < RuleError; end

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

  def self.parse_file(file, options = {})
    parse(Pathname(file).expand_path.read, options)
  end

  def self.parse(str, options = {})
    options = {
    }.merge(options)
    parser = [KifFormat::Parser, Ki2Format::Parser].find{|parser|parser.resolved?(str)}
    parser or raise FileFormatError, "フォーマットがおかしい : #{str}"
    parser.parse(str, options)
  end
end

require_relative "bushido/version"
require_relative "bushido/position"
require_relative "bushido/point"
require_relative "bushido/location"
require_relative "bushido/piece"
require_relative "bushido/board"
require_relative "bushido/utils"
require_relative "bushido/soldier"
require_relative "bushido/player"
require_relative "bushido/order_parser"
require_relative "bushido/movabler"
require_relative "bushido/kifu_dsl"
require_relative "bushido/frame"

require_relative "bushido/base_format"
require_relative "bushido/kif_format"
require_relative "bushido/ki2_format"

module Bushido
  Board.send(:include, BaseFormat::Board)
  Soldier.send(:include, BaseFormat::Soldier)
end

module Bushido
  if $0 == __FILE__
    mediator = Mediator.start
    mediator.piece_plot
    mediator.execute("７六歩")
    mediator.execute("３四歩")
    puts mediator
  end
end
