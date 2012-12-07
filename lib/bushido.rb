# -*- coding: utf-8 -*-
#
# 将棋ライブラリ
#

require "active_support/core_ext/string"
require "rain_table"

require_relative "bushido/version"

module Bushido
  class LogicError < StandardError; end
  class SyntaxError < StandardError; end
  class PieceNotFound < StandardError; end
  class PieceOverwrideError < StandardError; end
  class SamePlayerSoldierOverwrideError < StandardError; end

  module Piece
    def self.create(key, *args)
      "Bushido::Piece::#{key.to_s.classify}".constantize.new(*args)
    end

    def self.collection
      [:pawn, :bishop, :rook, :lance, :knight, :silver, :gold, :king].collect{|key|create(key)}
    end

    def self.get(arg)
      collection.find{|piece|piece.name == arg || piece.sym_name == arg}
    end

    class Base
      def name
      end

      def sym_name
        self.class.name.demodulize.underscore.to_sym
      end

      def transformable?
        true
      end

      def basic_vectors1
        []
      end

      def basic_vectors2
        []
      end

      def promoted_vectors1
        []
      end

      def promoted_vectors2
        []
      end

      def vectors1(promoted = false)
        if !transformable? && promoted
          raise NotTransformable
        end
        if promoted
          promoted_vectors1
        else
          basic_vectors1
        end
      end

      def vectors2(promoted = false)
        if !transformable? && promoted
          raise NotTransformable
        end
        if promoted
          promoted_vectors2
        else
          basic_vectors2
        end
      end
    end

    module Golden
      def promoted_vectors1
        Gold.__base__
      end
    end

    module Brave
      def promoted_vectors1
        King.__base__
      end

      def promoted_vectors2
        basic_vectors2
      end
    end

    class Pawn < Base
      include Golden

      def name
        "歩"
      end

      def basic_vectors1
        [[0, -1]]
      end
    end

    class Bishop < Base
      include Brave

      def name
        "角"
      end

      def basic_vectors2
        [
          [-1, -1], nil, [1, -1],
          nil,      nil,     nil,
          [-1,  1], nil, [1,  1],
        ]
      end
    end

    class Rook < Base
      include Brave

      def name
        "飛"
      end

      def basic_vectors2
        [
          nil,      [0, -1],     nil,
          [-1,  0],          [1,  0],
          nil,      [0,  1],     nil,
        ]
      end

      # def cleave?
      #   true
      # end
    end

    class Lance < Base
      include Golden

      def name
        "香"
      end

      def basic_vectors2
        [[0, -1]]
      end
    end

    class Knight < Base
      include Golden

      def name
        "桂"
      end

      def basic_vectors1
        [[-1, -2], [1, -2]]
      end
    end

    class Silver < Base
      include Golden

      def name
        "銀"
      end

      def basic_vectors1
        [
          [-1, -1], [0, -1], [1, -1],
          nil,          nil,     nil,
          [-1,  1],     nil, [1,  1],
        ]
      end
    end

    class Gold < Base
      def self.__base__
        [
          [-1, -1], [0, -1], [1, -1],
          [-1,  0],          [1,  0],
          nil,      [0,  1],     nil,
        ]
      end

      def name
        "金"
      end

      def basic_vectors1
        self.class.__base__
      end

      def transformable?
        false
      end
    end

    class King < Base
      def self.__base__
        [
          [-1, -1], [0, -1], [1, -1],
          [-1,  0],     nil, [1,  0],
          [-1,  1], [0,  1], [1,  1],
        ]
      end

      def name
        "玉"
      end

      def basic_vectors1
        self.class.__base__
      end

      def transformable?
        false
      end
    end
  end

  class Soldier
    attr_accessor :player, :piece, :promoted

    def initialize(player, piece, promoted = false)
      @player = player
      @piece = piece
      @promoted = promoted
    end

    def to_s
      "#{@promoted ? '成' : ''}#{@piece.name}#{@player.arrow}"
    end

    def inspect
      "<#{@player.location_mark}#{current_point.name}#{self}>"
    end

    def to_text
      "#{@player.location_mark}#{current_point.name}#{self}"
    end

    def current_point
      Point.parse(@player.field.matrix.invert[self])
    end

    # def moveable_all_cells2
    #   moveable_all_cells.collect{|point|Point.parse(point)}
    # end

    def moveable_all_cells
      list = []
      list += moveable_all_cells1(@piece.vectors1(@promoted), false)
      list += moveable_all_cells1(@piece.vectors2(@promoted), true)
      list.uniq
    end

    def moveable_all_cells1(vectors, loop)
      vectors.uniq.compact.each_with_object([]) do |vector, list|
        point = current_point
        loop do
          point = point.add_vector(vector)
          unless point.valid?
            break
          end
          target = @player.field.fetch(point)
          if target.nil?
            list << point
          else
            raise LogicError unless target.kind_of? Soldier
            if target.player == player # 自分の駒は追い抜けない(駒の所有者が自分だったので追い抜けない)
              break
            else
              # 相手の駒だったので置ける
              list << point
              break
            end
          end
          unless loop
            break
          end
        end
      end
    end
  end

  class Position
    attr_accessor :value

    private_class_method :new

    def self.parse(arg)
      case arg
      when String
        v = units.find_index{|e|e == arg}
        v or raise SyntaxError, "#{arg.inspect} が #{units} の中にありません"
      when Position
        v = arg.value
      else
        v = arg
      end
      new(v)
    end

    def self.value_range
      (0 .. units.size - 1)
    end

    def valid?
      self.class.value_range.include?(@value)
    end

    def initialize(value)
      @value = value
    end

    def name
      self.class.units[@value]
    end

    def reverse
      self.class.parse(self.class.units.size - 1 - @value)
    end

    def inspect
      "#<#{self.class.name}:#{object_id} #{name.inspect} #{@value}>"
    end
  end

  class Hposition < Position
    def self.units
      "987654321".scan(/./)
    end
  end

  class Vposition < Position
    def self.units
      "一二三四五六七八九".scan(/./)
    end

    def self.parse(arg)
      if arg.kind_of?(String) && arg.match(/\A\d\z/)
        arg = arg.tr("1-9", units.join)
      end
      super
    end
  end

  class Point
    attr_accessor :x, :y

    private_class_method :new

    def self.[](arg)
      parse(arg)
    end

    def self.parse(arg)
      x = nil
      y = nil

      case arg
      when Point
        a, b = arg.to_xy
        x = Hposition.parse(a)
        y = Vposition.parse(b)
      when Array
        a, b = arg
        x = Hposition.parse(a)
        y = Vposition.parse(b)
      when String
        if md = arg.match(/(.)(.)/)
          a, b = md.captures
          x = Hposition.parse(a)
          y = Vposition.parse(b)
        else
          raise SyntaxError, "#{arg.inspect}"
        end
      else
        raise SyntaxError, "#{arg.inspect}"
      end

      new(x, y)
    end

    def initialize(x, y)
      @x = x
      @y = y
    end

    def reverse
      self.class.parse([@x.reverse, @y.reverse])
    end

    def to_xy
      [@x.value, @y.value]
    end

    def name
      if valid?
        [@x, @y].collect(&:name).join
      else
        "盤外"
      end
    end

    def inspect
      "#<#{self.class.name}:#{object_id} #{name.inspect} #{to_xy.inspect}>"
    end

    def add_vector(vector)
      x, y = vector
      self.class.parse([@x.value + x, @y.value + y])
    end

    def valid?
      @x.valid? && @y.valid?
    end
  end

  class Field
    attr_accessor :matrix

    def initialize
      @matrix = {}
    end

    def pick_down(point, soldier)
      if fetch(point)
        raise PieceOverwrideError
      end
      @matrix[point.to_xy] = soldier
    end

    def fetch(point)
      @matrix[point.to_xy]
    end

    def pick_up(point)
      @matrix.delete(point.to_xy)
    end

    def to_s
      rows = Vposition.units.size.times.collect{|y|
        Hposition.units.size.times.collect{|x|
          @matrix[[x, y]]
        }
      }
      RainTable::TableFormatter.format(Hposition.units, rows, :header => true)
    end
  end

  class Player
    attr_accessor :name, :field, :location, :pieces

    def initialize(name, field, location)
      @name = name
      @field = field
      @location = location

      deal
    end

    def deal
      @pieces = first_distributed_pieces.collect{|info|
        info[:count].times.collect{ Piece.get(info[:piece]) }
      }.flatten
    end

    def first_distributed_pieces
      [
        {:count => 9, :piece => "歩"},
        {:count => 1, :piece => "角"},
        {:count => 1, :piece => "飛"},
        {:count => 2, :piece => "香"},
        {:count => 2, :piece => "桂"},
        {:count => 2, :piece => "銀"},
        {:count => 2, :piece => "金"},
        {:count => 1, :piece => "玉"},
      ]
    end

    def setup
      init_soldiers(first_placements)
    end

    def init_soldiers(table)
      table.each{|info|init_soldier(info)}
    end

    def init_soldier(info)
      promoted = false
      if info.kind_of?(String)
        if md = info.match(/(?<point>..)(?<piece>.)(?<options>.*)/)
          point = Point.parse(md[:point])
          piece = pick_out(md[:piece])
          promoted = md[:options] == "成"
        else
          raise SyntaxError, info.inspect
        end
      else
        point = Point.parse(info[:point])
        piece = pick_out(info[:piece])
        promoted = info[:promoted]
      end
      if @location == :lower
      else
        point = point.reverse
      end
      @field.pick_down(point, Soldier.new(self, piece, promoted))
    end

    def first_placements
      [
        "9七歩", "8七歩", "7七歩", "6七歩", "5七歩", "4七歩", "3七歩", "2七歩", "1七歩",
        "8八角", "2八飛",
        "9九香", "8九桂", "7九銀", "6九金", "5九玉", "4九金", "3九銀", "2九桂", "1九香",
      ]
    end

    def arrow
      @location == :lower ? "" : "↓"
    end

    def location_mark
      @location == :lower ? "▲" : "▽"
    end

    def piece_fetch(arg)
      @pieces.find{|piece|piece.sym_name == arg || piece.name == arg} or raise PieceNotFound
    end

    def pick_out(arg)
      piece = piece_fetch(arg)
      @pieces = @pieces.reject{|e|e == piece}
      piece
    end

    def soldiers
      @field.matrix.values.find_all{|soldier|soldier.player == self}
    end

    def move_to(a, b)
      a = Point.parse(a)
      b = Point.parse(b)
      soldier = @field.pick_up(a)
      target_soldier = @field.fetch(b)
      if target_soldier
        if target_soldier.player == self
          raise SamePlayerSoldierOverwrideError
        end
        @field.pick_up(b)
        @pieces << target_soldier.piece
      end
      @field.pick_down(b, soldier)
    end

    def execute(str)
      md = str.match(/(?<point>..)(?<piece>.)(?<options>.*)/)
      point = Point.parse(md[:point])

      source = nil
      soldiers.each{|soldier|
        all_cell = soldier.moveable_all_cells
        if all_cell.any?{|xy|xy == point.to_xy}
          if soldier.piece.name == md[:piece]
            source = soldier
            break
          end
        end
      }

      source_point = @field.matrix.invert[source]
      move_to(source_point, point)
    end
  end

  if $0 == __FILE__
    @field = Field.new
    @players = []
    @players << Player.new("先手", @field, :lower)
    @players << Player.new("後手", @field, :upper)
    @players.each(&:setup)
    @players[0].execute("7六歩")
    puts @field

    # @players[0].move_to("7七", "7六")
    # puts @field
    # @players[1].move_to("3三", "3四")
    # puts @field
    # @players[0].move_to("8八", "2二")
    # puts @field
  end
end
