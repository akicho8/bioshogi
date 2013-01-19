# -*- coding: utf-8 -*-

require "active_support/core_ext/string"
require "active_support/configurable"
require "pry-debugger"

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
  class SyntaxError < BushidoError; end
  class PieceNotFound < BushidoError; end
  class PieceAlredyExist < BushidoError; end
  class SamePlayerSoldierOverwrideError < BushidoError; end
  class AlredyPromoted < BushidoError; end
  class NotFoundOnBoard < BushidoError; end
  class PromotedPieceToNormalPiece < BushidoError; end
  class NotPutInPlaceNotBeMoved < BushidoError; end
  class BeforePointNotFound < BushidoError; end
  class FileFormatError < BushidoError; end
  class RuleError < SyntaxError; end

  # 構文エラーから発生する継続が難しいエラー
  class PositionSyntaxError < SyntaxError; end
  class PointSyntaxError < SyntaxError; end

  # 別に問題ないけど将棋のルール上エラーとするもの
  class NotPromotable < RuleError; end
  class PromotedPiecePutOnError < RuleError; end
  class DoublePawn < RuleError; end

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

  class Location
    # Location.parse(:black).name # => "先手"
    def self.parse(arg)
      if arg.kind_of? self
        return arg
      end
      info = [
        {:key => :black, :mark => "▲", :name => "先手", :varrow => " ", :zarrow => ""},
        {:key => :white, :mark => "▽", :name => "後手", :varrow => "v", :zarrow => "↓"},
      ].find{|e|e.values.include?(arg)}
      info or raise SyntaxError, "#{arg.inspect}"
      new(info)
    end

    def initialize(info)
      @info = info
    end

    [:key, :mark, :name, :varrow, :zarrow].each do |v|
      define_method(v){
        @info[v]
      }
    end

    # mark_with_name # => "▲先手"
    def mark_with_name
      "#{mark}#{name}"
    end

    def black?
      key == :black
    end

    def white?
      key == :white
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

require_relative "bushido/base_format"
require_relative "bushido/kif_format"
require_relative "bushido/ki2_format"

module Bushido
  Board.send(:include, BaseFormat::Board)
  Soldier.send(:include, BaseFormat::Soldier)

  Board.send(:include, KifFormat::Board)
  Soldier.send(:include, KifFormat::Soldier)

  Board.send(:include, Ki2Format::Board)
  Soldier.send(:include, Ki2Format::Soldier)
end

module Bushido
  if $0 == __FILE__
    frame = LiveFrame.basic_instance
    frame.piece_plot
    frame.execute("７六歩")
    frame.execute("３四歩")
    puts frame
  end
end
