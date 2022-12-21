module Bioshogi
  class V
    class << self
      def one
        self[1, 1]
      end

      def half
        self[0.5, 0.5]
      end

      def [](*args)
        new(*args)
      end
    end

    attr_reader :x
    attr_reader :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def to_a
      [@x, @y]
    end

    def collect(&block)
      self.class.new(*to_a.collect(&block)) # FIXME: class.new がとれたらとる
    end

    def ==(other)
      @x == other.x && @y == other.y
    end

    def eql?(other)
      @x == other.x && @y == other.y
    end

    def <=>(other)
      to_a <=> other.to_a
    end

    def to_s
      to_a.to_s
    end

    def inspect
      "<#{self}>"
    end

    def add(other)
      if other.kind_of?(self.class)
        self.class.new(@x + other.x, @y + other.y)
      elsif other.respond_to?(:to_a)
        self + self.class.new(*other)
      else
        self.class.new(@x + other, @y + other)
      end
    end

    def sub(other)
      if other.kind_of?(self.class)
        self.class.new(@x - other.x, @y - other.y)
      elsif other.respond_to?(:to_a)
        self - self.class.new(*other)
      else
        self.class.new(@x - other, @y - other)
      end
    end

    def mul(other)
      if other.kind_of?(self.class)
        self.class.new(@x * other.x, @y * other.y)
      elsif other.respond_to?(:to_a)
        self * self.class.new(*other)
      else
        self.class.new(@x * other, @y * other)
      end
    end

    def div(other)
      if other.kind_of?(self.class)
        self.class.new(@x / other.x, @y / other.y)
      elsif other.respond_to?(:to_a)
        self / self.class.new(*other)
      else
        self.class.new(@x / other, @y / other)
      end
    end

    alias + add
    alias - sub
    alias * mul
    alias / div
  end
end
