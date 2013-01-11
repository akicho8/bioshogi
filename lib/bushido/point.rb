# -*- coding: utf-8 -*-
#
# 座標
#
#   Point["4三"].name   # => "4三"
#   Point["４三"].name  # => "4三"
#   Point["43"].name    # => "4三"
#
module Bushido #:nodoc:
  class Point
    include ActiveSupport::Configurable
    config_accessor :promoted_area_height
    config.promoted_area_height = 3

    attr_accessor :x, :y

    private_class_method :new

    # parseのalias
    def self.[](arg)
      parse(arg)
    end

    def self.parse(arg)
      x = nil
      y = nil

      case arg
      when Point
        a, b = arg.to_xy
        x = Position::Hpos.parse(a)
        y = Position::Vpos.parse(b)
      when Array
        a, b = arg
        x = Position::Hpos.parse(a)
        y = Position::Vpos.parse(b)
      when String
        if md = arg.match(/\A(.)(.)\z/)
          a, b = md.captures
          x = Position::Hpos.parse(a)
          y = Position::Vpos.parse(b)
        else
          raise PointSyntaxError, "座標を2文字で表記していません : #{arg.inspect}"
        end
      else
        raise MustNotHappen, "引数がめちゃくちゃです : Point.parse(#{arg.inspect})"
      end

      new(x, y)
    end

    def initialize(x, y)
      @x = x
      @y = y
    end

    # 座標を反転させて新しいPointオブジェクトを返す
    def reverse
      self.class.parse([@x.reverse, @y.reverse])
    end

    # 内部座標を返す
    def to_xy
      [@x.value, @y.value]
    end

    # 座標を正式な名前で返す
    def name
      if valid?
        [@x, @y].collect(&:name).join
      else
        "盤外"
      end
    end

    # kif形式用の二桁の数座標を返す
    #   Point["２四"].number_format # => "24"
    def number_format
      [@x, @y].collect(&:number_format).join
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
      if location == :black
        @y.value < promoted_area_height
      else
        @y.value >= (@y.class.units.size - promoted_area_height)
      end
    end
  end
end
