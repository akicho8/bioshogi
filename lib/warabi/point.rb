# frozen-string-literal: true
#
# 座標
#
#   Point["４三"].name   # => "４三"
#   Point["４三"].name  # => "４三"
#   Point["43"].name    # => "４三"
#
module Warabi
  class Point
    attr_accessor :x, :y

    class << self
      private :new

      include Enumerable

      # すべての座標を返す
      #   Point.collect { |point| ... }
      def each(&block)
        Position::Vpos.dimension.times.flat_map { |y|
          Position::Hpos.dimension.times.collect { |x|
            Point[[x, y]]
          }
        }.each(&block)
      end

      def fetch(value)
        lookup(value) or raise PointSyntaxError, "座標が読み取れません : #{value.inspect}"
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
          x = Position::Hpos.lookup(a)
          y = Position::Vpos.lookup(b)
        when String
          if md = value.match(/\A(?<x>.)(?<y>.)\z/)
            x = Position::Hpos.lookup(md[:x])
            y = Position::Vpos.lookup(md[:y])
          end
        end

        # if x && y
        #   @memo ||= {}
        #   @memo[[x, y]] ||= new(x, y).freeze
        # end
        if x && y
          new(x, y).freeze
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

    # 内部状態
    #   Point["５五"].inspect # => #<Warabi::Point:70223123742360 "５五">
    def inspect
      "#<#{self.class.name}:#{object_id} #{name.inspect}>"
    end

    # 自分自身を返す
    def to_point
      self
    end

    # 内部座標を返す
    #   Point["１一"].to_xy # => [8, 0]
    def to_xy
      [@x.value, @y.value]
    end

    # 座標を反転させて新しいPointオブジェクトを返す
    def reverse
      self.class.fetch([@x.reverse, @y.reverse])
    end

    # 後手なら反転する
    # 先手から見た状態に統一したい場合に使う
    def reverse_if_white(location)
      if Location[location].key == :white
        reverse
      else
        self
      end
    end

    # 座標を正式な名前で返す
    #   Point["55"] # => "５五"
    def name
      if valid?
        to_a.collect(&:name).join
      else
        "盤外"
      end
    end

    # 座標を正式な名前で返す
    #   "#{point}歩" などと気軽に書けるようにするため
    def to_s
      name
    end

    # kif形式用の二桁の数座標を返す
    #   Point["２四"].number_format # => "24"
    def number_format
      to_a.collect(&:number_format).join
    end

    def to_sfen
      to_a.collect(&:to_sfen).join
    end

    def to_a
      [@x, @y]
    end

    # ベクトルを加算して新しい座標オブジェクトを返す
    #   Point.fetch("５五").vector_add([1, 2]).name # => "４七"
    def vector_add(vector)
      x, y = vector
      self.class.fetch([@x.value + x, @y.value + y])
    end

    # 盤面内か？
    def valid?
      @x.valid? && @y.valid?
    end

    # 盤面外か？
    def invalid?
      !valid?
    end

    #   Point["５五"] == Point["55"] # => true
    def ==(other)
      # to_xy == other.to_xy
      eql?(other)
    end

    # ソート用
    def <=>(other)
      to_xy <=> other.to_xy
    end

    if true
      # Soldier で [1, 2, 3] - [1, 2] => [3] のようにできるようにするため
      def eql?(other)
        self.class == other.class && to_xy == other.to_xy
      end

      def hash
        # to_a.hash
        to_xy.hash
      end
    end

    # 相手陣地に入っているか？
    #   Point.fetch("１三").promotable?(:black) # => true
    #   Point.fetch("１四").promotable?(:black) # => false
    def promotable?(location)
      @y.promotable?(location)
    end
  end
end
