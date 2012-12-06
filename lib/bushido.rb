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

  module Piece
    def self.create(key, *args)
      "Bushido::Piece::#{key.to_s.classify}".constantize.new(*args)
    end

    def self.collection
      [:fu, :ka, :hi, :ky, :ke, :gi, :ki, :ou].collect{|key|create(key)}
    end

    def self.get(arg)
      collection.find{|piece|piece.name == arg}
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

      def cleave?
        false
      end
    end

    module Golden
      def transformed_movable_cells
        [
          [-1, -1], [0, -1], [1, -1],
          [-1,  0],          [1,  0],
          nil,      [0,  1],     nil,
        ].compact
      end

      module_function :transformed_movable_cells
    end

    module Brave
      def transformed_movable_cells
        [
          [-1, -1], [0, -1], [1, -1],
          [-1,  0],     nil, [1,  0],
          [-1,  1], [0,  1], [1,  1],
        ]
      end
    end

    class Fu < Base
      include Golden

      def name
        "歩"
      end

      def basic_movable_cells
        [[0, -1]]
      end
    end

    class Ka < Base
      include Brave

      def name
        "角"
      end

      def basic_movable_cells
        [
          [-1, -1], nil, [1, -1],
          nil,      nil,     nil,
          [-1,  1], nil, [1,  1],
        ]
      end

      def cleave?
        true
      end
    end

    class Hi < Base
      include Brave

      def name
        "飛"
      end

      def basic_movable_cells
        [
          nil,      [0, -1],     nil,
          [-1,  0],          [1,  0],
          nil,      [0,  1],     nil,
        ].compact
      end

      def cleave?
        true
      end
    end

    class Ky < Base
      include Golden

      def name
        "香"
      end

      def basic_movable_cells
        [[0, -1]]
      end

      def cleave?
        true
      end
    end

    class Ke < Base
      include Golden

      def name
        "桂"
      end

      def basic_movable_cells
        [[-1, -2], [1, -2]]
      end
    end

    class Gi < Base
      include Golden

      def name
        "銀"
      end

      def basic_movable_cells
        [
          [-1, -1], [0, -1], [1, -1],
          nil,          nil,     nil,
          [-1,  1],     nil, [1,  1],
        ]
      end
    end

    class Ki < Base
      def name
        "金"
      end

      def basic_movable_cells
        Golden.transformed_movable_cells
      end

      def transformable?
        false
      end
    end

    class Ou < Base
      def name
        "王"
      end

      def basic_movable_cells
        [
          [-1, -1], [0, -1], [1, -1],
          [-1,  0],     nil, [1,  0],
          [-1,  1], [0,  1], [1,  1],
        ]
      end

      def transformable?
        false
      end
    end
  end

  class Soldier
    attr_accessor :player, :piece, :transform

    def initialize(player, piece, transform = false)
      @player = player
      @piece = piece
      @transform = transform
    end

    def to_s
      "#{@transform ? '成' : ''}#{@piece.name}#{@player.arrow}"
    end

    def inspect
      "<#{@player.name}の#{current_point.name}#{self}>"
    end

    def current_point
      Point.parse(@player.field.matrix.invert[self])
    end

    def moveable_all_cells
      @piece.basic_movable_cells.compact.each_with_object([]) do |vector, list|
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
          unless @piece.cleave?
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

    def put_on(point, soldier)
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
      @pieces = first_distributed_pieces.collect{|info|
        info[:count].times.collect {
          Piece.create(info[:key])
        }
      }.flatten
    end

    def first_distributed_pieces
      [
        {:count => 9, :key => :fu},
        {:count => 1, :key => :ka},
        {:count => 1, :key => :hi},
        {:count => 2, :key => :ky},
        {:count => 2, :key => :ke},
        {:count => 2, :key => :gi},
        {:count => 2, :key => :ki},
        {:count => 1, :key => :ou},
      ]
    end

    def setup
      reset_field(first_deployment)
    end

    def reset_field(table)
      table.each{|info|
        piece = pick_out(info[:key])
        point = Point.parse(info[:point])
        if @location == :kotti
        else
          point = point.reverse
        end
        @field.put_on(point, Soldier.new(self, piece))
      }
    end

    def first_deployment
      [
        {:point => "9七", :key => :fu},
        {:point => "8七", :key => :fu},
        {:point => "7七", :key => :fu},
        {:point => "6七", :key => :fu},
        {:point => "5七", :key => :fu},
        {:point => "4七", :key => :fu},
        {:point => "3七", :key => :fu},
        {:point => "2七", :key => :fu},
        {:point => "1七", :key => :fu},
        {:point => "8八", :key => :ka},
        {:point => "2八", :key => :hi},
        {:point => "9九", :key => :ky},
        {:point => "8九", :key => :ke},
        {:point => "7九", :key => :gi},
        {:point => "6九", :key => :ki},
        {:point => "5九", :key => :ou},
        {:point => "4九", :key => :ki},
        {:point => "3九", :key => :gi},
        {:point => "2九", :key => :ke},
        {:point => "1九", :key => :ky},
      ]
    end

    def arrow
      if @location == :kotti
        ""
      else
        "↓"
      end
    end

    def pick_out(key)
      if index = @pieces.find_index{|piece|piece.sym_name == key}
        piece = @pieces[index]
        @pieces[index] = nil
        @pieces.compact!
        piece
      end
    end

    def soldiers
      @field.matrix.values.find_all{|soldier|soldier.player == self}
    end

    def move_to(a, b)
      a = Point.parse(a)
      b = Point.parse(b)
      soldier = @field.pick_up(a)
      @field.put_on(b, soldier)
    end

    def execute(str)
      md = str.match(/(?<point>..)(?<piece>.)(?<option>.*)/)
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
    @players << Player.new("先手", @field, :kotti)
    @players << Player.new("後手", @field, :atti)
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
