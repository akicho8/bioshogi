# frozen-string-literal: true
#
# 座標
#
#   Place["４三"].name   # => "４三"
#   Place["４三"].name  # => "４三"
#   Place["43"].name    # => "４三"
#

module Bioshogi
  class Place
    attr_accessor :x, :y

    class << self
      private :new

      include Enumerable

      def cache_clear
        @foo = nil
      end

      def each(&block)
        @foo ||= Dimension::PlaceY.dimension.times.flat_map { |y|
          Dimension::PlaceX.dimension.times.collect { |x|
            self[[x, y]]
          }
        }
        @foo.each(&block)
      end

      def fetch(value)
        lookup(value) or raise SyntaxDefact, "座標が読み取れません : #{value.inspect}"
      end

      def lookup(value)
        if value.kind_of?(self)
          return value
        end

        x = nil
        y = nil

        case value
        when Array
          a, b = value
          x = Dimension::PlaceX.lookup(a)
          y = Dimension::PlaceY.lookup(b)
        when String
          a, b = value.chars
          x = Dimension::PlaceX.lookup(a)
          y = Dimension::PlaceY.lookup(b)
        else
          if respond_to?(:to_a)
            return lookup(value.to_a)
          end
        end

        if x && y
          @memo ||= {}
          @memo[x] ||= {}
          @memo[x][y] ||= new(x, y).freeze
        end
      end

      def [](value)
        lookup(value)
      end

      def regexp
        /[一二三四五六七八九１-９1-9]{2}/
      end
    end

    def initialize(x, y)
      @x = x
      @y = y
    end

    def inspect
      "#<#{self.class.name} #{name}>"
    end

    # 180度回転 ※上下対象ではない
    def flip
      self.class.fetch([@x.flip, @y.flip])
    end

    # x座標のみ反転
    def flop
      self.class.fetch([@x.flip, @y])
    end

    def flip_if_white(location)
      if Location[location].key == :white
        flip
      else
        self
      end
    end

    def name
      to_a.collect { |e| e.name }.join
    end

    def zenkaku_number
      to_a.collect(&:zenkaku_number).join
    end

    def yomiage
      to_a.collect(&:yomiage).join
    end

    def to_s
      name
    end

    def number_hankaku
      to_a.collect(&:number_hankaku).join
    end

    def to_sfen
      to_a.collect(&:to_sfen).join
    end

    def to_xy
      [@x.value, @y.value]
    end

    # "６八銀" なら [6, 8]
    def to_human_int
      to_a.collect(&:to_human_int)
    end

    # "６八銀" なら {x:6, y:8}
    def to_human_h
      { x: @x.to_human_int, y: @y.to_human_int }
    end

    def to_a
      [@x, @y]
    end

    def vector_add(vector)
      self.class.lookup([@x.value + vector.x, @y.value + vector.y])
    end

    # def valid?
    #   @x.valid? && @y.valid?
    # end
    #
    # def invalid?
    #   !valid?
    # end

    def ==(other)
      eql?(other)
    end

    def <=>(other)
      to_xy <=> other.to_xy
    end

    def hash
      to_xy.hash
    end

    def eql?(other)
      self.class == other.class && to_xy == other.to_xy
    end

    def promotable?(location)
      @y.promotable?(location)
    end
  end
end
