#
# 座標
#
#   Point["4三"].name   # => "4三"
#   Point["４三"].name  # => "4三"
#   Point["43"].name    # => "4三"
#
module Bushido
  class Point
    attr_accessor :x, :y

    class << self
      private :new

      include Enumerable

      # すべての座標を返す
      #   Point.collect{|point|...}
      def each(&block)
        Position::Vpos.size.times.collect{|y|
          Position::Hpos.size.times.collect{|x|
            Point[[x, y]]
          }
        }.flatten.each(&block)
      end

      # parseのalias
      #   Point["4三"].name # => "4三"
      def [](arg)
        parse(arg)
      end

      # 座標のパース
      #   Point.parse["4三"].name # => "4三"
      def parse(arg)
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
          if md = arg.match(/\A(?<x>.)(?<y>.)\z/)
            x = Position::Hpos.parse(md[:x])
            y = Position::Vpos.parse(md[:y])
          else
            raise PointSyntaxError, "座標を2文字で表記していません : #{arg.inspect}"
          end
        else
          raise MustNotHappen, "引数が異常です : #{arg.inspect}"
        end

        new(x, y)
      end

      def regexp
        /#{Position::Hpos.regexp}#{Position::Vpos.regexp}/o
      end
    end

    def initialize(x, y)
      @x = x
      @y = y
    end

    # 内部状態
    #   Point["５五"].inspect # => #<Bushido::Point:70223123742360 "5五">
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
      self.class.parse([@x.reverse, @y.reverse])
    end

    # 後手なら反転する
    def as_location(location)
      if Location[location].white?
        reverse
      else
        self
      end
    end

    # 座標を正式な名前で返す
    #   Point["55"] # => "５五"
    def name
      if valid?
        [@x, @y].collect(&:name).join
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
      [@x, @y].collect(&:number_format).join
    end

    # ベクトルを加算して新しい座標オブジェクトを返す
    #   Point.parse("５五").add_vector([1, 2]).name # => "4七"
    def add_vector(vector)
      x, y = vector
      self.class.parse([@x.value + x, @y.value + y])
    end

    # 盤面内か？
    def valid?
      @x.valid? && @y.valid?
    end

    # 比較
    #   Point["５五"] == Point["55"] # => true
    def ==(other)
      to_xy == other.to_xy
    end

    # 相手陣地に入っているか？
    #   Point.parse("１三").promotable?(:black) # => true
    #   Point.parse("１四").promotable?(:black) # => false
    def promotable?(location)
      @y.promotable?(location)
    end
  end
end
