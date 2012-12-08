# -*- coding: utf-8 -*-
#
# 将棋ライブラリ
#

require "active_support/core_ext/string"
require "active_support/configurable"

require "rain_table"

require_relative "bushido/version"

module Bushido
  include ActiveSupport::Configurable
  config_accessor :format
  config.format = :basic

  class BushidoError < StandardError; end

  class MustNotHappen < BushidoError; end
  class RuleError < BushidoError; end
  class SyntaxError < BushidoError; end
  class PointSyntaxError < BushidoError; end
  class UnknownPositionName < BushidoError; end
  class PieceNotFound < BushidoError; end
  class PieceAlredyExist < BushidoError; end
  class SamePlayerSoldierOverwrideError < BushidoError; end
  class NotPromotable < BushidoError; end
  class AlredyPromoted < BushidoError; end

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

      def promotable?
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
        assert_promotable(promoted)
        promoted ? promoted_vectors1 : basic_vectors1
      end

      def vectors2(promoted = false)
        assert_promotable(promoted)
        promoted ? promoted_vectors2 : basic_vectors2
      end

      def assert_promotable(promoted)
        if !promotable? && promoted
          raise NotPromotable
        end
      end

      def inspect
        "<#{self.class.name}:#{object_id} #{name} #{sym_name}>"
      end
    end

    module AsGoldIfPromoted
      def promoted_vectors1
        Gold.basic_pattern
      end
    end

    module Brave
      def promoted_vectors1
        King.basic_pattern
      end

      def promoted_vectors2
        basic_vectors2
      end
    end

    class Pawn < Base
      include AsGoldIfPromoted

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
    end

    class Lance < Base
      include AsGoldIfPromoted

      def name
        "香"
      end

      def basic_vectors2
        [[0, -1]]
      end
    end

    class Knight < Base
      include AsGoldIfPromoted

      def name
        "桂"
      end

      def basic_vectors1
        [[-1, -2], [1, -2]]
      end
    end

    class Silver < Base
      include AsGoldIfPromoted

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
      def self.basic_pattern
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
        self.class.basic_pattern
      end

      def promotable?
        false
      end
    end

    class King < Base
      def self.basic_pattern
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
        self.class.basic_pattern
      end

      def promotable?
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

      if !piece.promotable? && promoted
        raise NotPromotable, piece.inspect
      end
    end

    def to_s
      "#{@promoted ? '成' : ''}#{@piece.name}#{@player.arrow}"
    end

    def inspect
      "<#{self.class.name}:#{object_id} #{to_text}>"
    end

    def to_text
      "#{@player.location_mark}#{current_point.name}#{self}"
    end

    def name
      to_text
    end

    def current_point
      Point.parse(@player.field.matrix.invert[self])
    end

    # FIXME: vectors1, vectors2 と分けるのではなくベクトル自体に繰り返しフラグを持たせる方法も検討
    def moveable_points
      list = []
      list += __moveable_points(@piece.vectors1(@promoted), false)
      list += __moveable_points(@piece.vectors2(@promoted), true)
      list.uniq
    end

    def __moveable_points(vectors, loop)
      vectors.uniq.compact.each_with_object([]) do |vector, list|
        point = current_point
        loop do
          if player.location == :upper
            vector = Vector.new(vector).reverse
          end
          point = point.add_vector(vector)
          unless point.valid?
            break
          end
          target = @player.field.fetch(point)
          if target.nil?
            list << point
          else
            unless target.kind_of? Soldier
              raise MustNotHappen, "得体の知れないものが盤上にいます : #{target.inspect}"
            end
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
        v or raise UnknownPositionName, "#{arg.inspect} が #{units} の中にありません"
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

    # "５五" の全角 "５" に対応するため
    def self.parse(arg)
      if arg.kind_of?(String) && arg.match(/[１-９]/)
        arg = arg.tr("１-９", units.reverse.join)
      end
      super
    end

    def to_s_digit
      name
    end
  end

  class Vposition < Position
    def self.units
      "一二三四五六七八九".scan(/./)
    end

    # "(52)" の "2" に対応するため
    def self.parse(arg)
      if arg.kind_of?(String) && arg.match(/\d/)
        arg = arg.tr("1-9", units.join)
      end
      super
    end

    def to_s_digit
      name.tr(self.class.units.join, "1-9")
    end
  end

  class Point
    include ActiveSupport::Configurable
    config_accessor :promoted_area_height
    config.promoted_area_height = 3

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
        if md = arg.match(/\A(.)(.)\z/)
          a, b = md.captures
          x = Hposition.parse(a)
          y = Vposition.parse(b)
        else
          raise PointSyntaxError, "座標を2文字で表記していません : #{arg.inspect}"
        end
      else
        raise MustNotHappen, "#{arg.inspect}"
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

    def to_s_digit
      [@x, @y].collect(&:to_s_digit).join
    end

    def inspect
      "#<#{self.class.name}:#{object_id} #{name.inspect}>"
    end

    def add_vector(vector)
      x, y = vector
      self.class.parse([@x.value + x, @y.value + y])
    end

    def valid?
      @x.valid? && @y.valid?
    end

    def to_point
      self
    end

    def ==(other)
      to_xy == other.to_xy
    end

    def promotable_area?(location)
      if location == :lower
        @y.value < promoted_area_height
      else
        @y.value > (@y.class.units.size - promoted_area_height)
      end
    end
  end

  class Field
    attr_accessor :matrix

    def initialize
      @matrix = {}
    end

    def put_on_at(point, soldier)
      if fetch(point)
        raise PieceAlredyExist
      end
      @matrix[point.to_xy] = soldier
    end

    def [](point)
      fetch(point)
    end

    def fetch(point)
      @matrix[Point[point].to_xy]
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
      rows = rows.zip(Vposition.units).collect{|e, u|e + [u]}
      RainTable::TableFormatter.format(Hposition.units + [""], rows, :header => true)
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
      table = first_placements.collect{|arg|parse_arg(arg)}
      if @location == :upper
        table.each{|info|info[:point] = info[:point].reverse}
      end
      side_soldiers_put_on(table)
    end

    def side_soldiers_put_on(table)
      table.each{|info|side_soldier_put_on(info)}
    end

    def side_soldier_put_on(arg)
      info = parse_arg(arg)
      @field.put_on_at(info[:point], Soldier.new(self, pick_out(info[:piece].name), info[:promoted]))
    end

    def parse_arg(arg)
      if arg.kind_of?(String)
        info = parse_string_arg(arg)
        if info[:options] == "成"
          raise SyntaxError, "駒の配置するときは「○成」ではなく「成○」: #{arg.inspect}"
        end
        info
      else
        piece = arg[:piece]
        if piece.kind_of?(String)
          piece = Piece.get(arg[:piece])
        end
        arg.merge(:point => Point[arg[:point]], :piece => piece)
      end
    end

    def parse_string_arg(str)
      if md = str.match(/(?<point>..)(?<promoted>成)?(?<piece>.)(?<options>.*)/)
        point = Point.parse(md[:point])
        piece = Piece.get(md[:piece])
        promoted = !!md[:promoted]
      else
        raise SyntaxError, str.inspect
      end
      {:point => point, :piece => piece, :promoted => promoted, :options => md[:options]}
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

    def move_to(a, b, promoted = false)
      a = Point.parse(a)
      b = Point.parse(b)

      if promoted
        if a.promotable_area?(location) || b.promotable_area?(location)
        else
          raise NotPromotable, "#{a.name}から#{b.name}への移動では成れません"
        end

        _soldier = @field.fetch(a)
        if _soldier.promoted
          raise AlredyPromoted, "#{_soldier.current_point.name}の#{_soldier.piece.name}はすでに成っています"
        end
      end

      soldier = @field.pick_up(a)
      target_soldier = @field.fetch(b)
      if target_soldier
        if target_soldier.player == self
          raise SamePlayerSoldierOverwrideError, "移動先の#{b.name}に自分の#{target_soldier.name}があります"
        end
        @field.pick_up(b)
        @pieces << target_soldier.piece
      end

      if promoted
        soldier.promoted = promoted
      end

      @field.put_on_at(b, soldier)
    end

    def execute(str)
      md = str.match(/(?<point>..)(?<piece>.)(?<options>.*)/)
      point = Point.parse(md[:point])
      piece = Piece.get(md[:piece])
      promoted = md[:options] == "成"

      source = nil
      soldiers.each{|soldier|
        points = soldier.moveable_points
        if points.any?{|e|e == point}
          if soldier.piece.class == piece.class
            source = soldier
            break
          end
        end
      }

      unless source
        raise RuleError, "#{point.name}に来れる#{piece.name}がありません。#{str.inspect} の指定が間違っているのかもしれません"
      end

      source_point = @field.matrix.invert[source]

      move_to(source_point, point, promoted)
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
