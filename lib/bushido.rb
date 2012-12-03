# -*- coding: utf-8 -*-
#
# 将棋ライブラリ
#

require "active_support/core_ext/string"
require "rain_table"

require_relative "bushido/version"

module Bushido
  module Piece
    def self.create(key, *args)
      "Bushido::Piece::#{key.to_s.classify}".constantize.new(*args)
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
          [-1,  0],          [1,  0],
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
        ].compact
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
          nil,                   nil,
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
          [-1,  0],          [1,  0],
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
  end

  class Position
    attr_accessor :value

    private_class_method :new

    def self.parse(arg)
      case arg
      when String
        v = units.find_index{|e|e == arg}
        v or raise ArgumentError, "#{arg.inspect} が #{units} の中にありません"
      when Position
        v = arg.value
      else
        v = arg
      end
      new(v)
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
  end

  class Point
    attr_accessor :x, :y

    private_class_method :new

    def self.parse(arg)
      x = nil
      y = nil

      case arg
      when Point
        x, y = arg.to_xy
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
          raise ArgumentError, "#{arg.inspect}"
        end
      else
        raise ArgumentError, "#{arg.inspect}"
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
      [@x, @y].collect(&:name).join
    end

    def inspect
      "#<#{self.class.name}:#{object_id} #{name.inspect} #{to_xy.inspect}>"
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

    def pick_out(key)
      if index = @pieces.find_index{|piece|piece.sym_name == key}
        piece = @pieces[index]
        @pieces[index] = nil
        @pieces.compact!
        piece
      end
    end

    def setup
      first_deployment.each{|info|
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

    def move_to(a, b)
      a = Point.parse(a)
      b = Point.parse(b)
      soldier = @field.pick_up(a)
      @field.put_on(b, soldier)
    end

    # def execute(str)
    #   md = str.match(/(?<point>..)(?<piece>.)(?<option>.*)/)
    #   point = Point.parse(md[:point])
    #   move_to(point)
    # end
    #
    # def piece_to_come_here(point)
    #   point = Point.parse(point)
    #   p point.to_xy
    #
    # end
  end

  if $0 == __FILE__
    @field = Field.new
    @players = []
    @players << Player.new("先手", @field, :kotti)
    @players << Player.new("後手", @field, :atti)
    @players.each(&:setup)
    # @players[0].piece_to_come_here("7六")
    # @players[0].execute("7六歩")
    puts @field
    @players[0].move_to("7七", "7六")
    puts @field
    @players[1].move_to("3三", "3四")
    puts @field
    @players[0].move_to("8八", "2二")
    puts @field
  end
end
