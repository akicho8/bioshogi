# frozen-string-literal: true
#
# 座標
#
#   Point["４三"].name   # => "４三"
#   Point["４三"].name  # => "４三"
#   Point["43"].name    # => "４三"
#
module Bushido
  class Point
    attr_accessor :x, :y

    class << self
      private :new

      include Enumerable

      # すべての座標を返す  ← これいる？？？
      #   Point.collect{|point|...}
      def each(&block)
        Position::Vpos.board_size.times.collect{|y|
          Position::Hpos.board_size.times.collect{|x|
            Point[[x, y]]
          }
        }.flatten.each(&block)
      end

      # parseのalias
      #   Point["４三"].name # => "４三"
      def [](value)
        parse(value)
      end

      # 座標のパース
      #   Point.parse["４三"].name # => "４三"
      def parse(value)
        x = nil
        y = nil

        case value
        when Array
          a, b = value
          x = Position::Hpos.parse(a)
          y = Position::Vpos.parse(b)
        when Point
          a, b = value.to_xy
          x = Position::Hpos.parse(a)
          y = Position::Vpos.parse(b)
        when String
          if md = value.match(/\A(?<x>.)(?<y>.)\z/)
            x = Position::Hpos.parse(md[:x])
            y = Position::Vpos.parse(md[:y])
          else
            raise PointSyntaxError, "座標を2文字で表記していません : #{value.inspect}"
          end
        else
          raise MustNotHappen, "引数が異常です : #{value.inspect}"
        end

        new(x, y)
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
    #   Point["５五"].inspect # => #<Bushido::Point:70223123742360 "５五">
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
    # 先手から見た状態に統一したい場合に使う
    def reverse_if_white_location(location)
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
    #   Point.parse("５五").vector_add([1, 2]).name # => "４七"
    def vector_add(vector)
      x, y = vector
      self.class.parse([@x.value + x, @y.value + y])
    end

    # 盤面内か？
    def valid?
      @x.valid? && @y.valid?
    end

    # 盤面外か？
    def invalid?
      !valid?
    end

    # 比較
    #   Point["５五"] == Point["55"] # => true
    def ==(other)
      to_xy == other.to_xy
    end

    # ソート用
    def <=>(other)
      to_xy <=> other.to_xy
    end

    # 相手陣地に入っているか？
    #   Point.parse("１三").promotable?(:black) # => true
    #   Point.parse("１四").promotable?(:black) # => false
    def promotable?(location)
      @y.promotable?(location)
    end
  end
end
