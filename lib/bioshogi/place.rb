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
    class << self
      private :new

      begin
        include Enumerable

        def each(&block)
          Dimension::DimensionRow.dimension_size.times.flat_map { |y|
            Dimension::DimensionColumn.dimension_size.times.collect { |x|
              self[[x, y]]
            }
          }.each(&block)
        end
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
          x = Dimension::DimensionColumn.lookup(a)
          y = Dimension::DimensionRow.lookup(b)
        when String
          a, b = value.chars
          x = Dimension::DimensionColumn.lookup(a)
          y = Dimension::DimensionRow.lookup(b)
        else
          if respond_to?(:to_a)
            return lookup(value.to_a)
          end
        end

        # 座標は最大で99なのでインスタンスを使いまわす
        # ただしグローバルな寸法が変わると不整合な状態になるため cache_clear を適切に呼ばないといけない
        if x && y
          @cache ||= {}
          @cache[x] ||= {}
          @cache[x][y] ||= new(x, y)
        end
      end

      def [](value)
        lookup(value)
      end

      def cache_clear
        if @cache
          @cache.each_value do |hv|
            hv.each_value(&:cache_clear)
          end
        end
      end

      def regexp
        /[一二三四五六七八九１-９1-9]{2}/
      end
    end

    attr_accessor :x, :y

    # for Soldier
    DELEGATE_METHODS = [
      *Dimension::DimensionColumn::DELEGATE_METHODS,
      *Dimension::DimensionRow::DELEGATE_METHODS,

      :relative_move_to,
      :move_to_xy,
      :king_default_place?,

      :move_to_bottom_edge,
      :move_to_top_edge,
      :move_to_left_edge,
      :move_to_right_edge,
    ]

    def initialize(x, y)
      @x = x
      @y = y
      @cache = {}
      freeze
    end

    def cache_clear
      to_a.each(&:cache_clear)
      @cache.clear
    end

    def inspect
      "#<#{self.class.name} #{name}>"
    end

    ################################################################################

    def to_s
      name
    end

    def name
      @cache[:name] ||= to_a.collect(&:name).join
    end

    def zenkaku_number
      @cache[:zenkaku_number] ||= to_a.collect(&:zenkaku_number).join
    end

    def hankaku_number
      @cache[:hankaku_number] ||= to_a.collect(&:hankaku_number).join
    end

    def yomiage
      @cache[:yomiage] ||= to_a.collect(&:yomiage).join
    end

    def to_sfen
      @cache[:to_sfen] ||= to_a.collect(&:to_sfen).join
    end

    def to_xy
      @cache[:to_xy] ||= to_a.collect(&:value)
    end

    # "６八銀" なら [6, 8]
    # キャッシュすると3倍速くなる
    def to_human_int
      @cache[:to_human_int] ||= to_a.collect(&:to_human_int)
    end

    # "６八銀" なら {x:6, y:8}
    # キャッシュすると2倍速くなる
    def to_human_h
      @cache[:to_human_h] ||= Hash[[:x, :y].zip(to_human_int)]
    end

    # ほぼキャッシュ効果なし。それどころか少し遅くなる。ただ配列を再生成しないのでこれでいいことにする。
    def to_a
      @cache[:to_a] ||= [@x, @y]
    end

    ################################################################################

    # 180度回転
    def flip
      @cache[:flip] ||= self.class.fetch(to_a.collect(&:flip))
    end

    # x座標のみ反転
    def flop
      @cache[:flop] ||= self.class.fetch([@x.flip, @y])
    end

    # Soldier では独自に定義しているためここに Soldier からここに委譲してはいけない
    def white_then_flip(location)
      if Location[location].key == :white
        flip
      else
        self
      end
    end

    ################################################################################

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

    ################################################################################ 移動

    # より抽象的な方法で移動した位置を返す
    def relative_move_to(location, vector, magnification: 1)
      if vector.kind_of?(Symbol)
        vector = V.public_send(vector)
      end
      xy_add(*(vector * location.sign_dir * magnification))
    end

    # 自玉の位置にいる？
    def king_default_place?(location)
      column_is_center?(location) && bottom_spaces(location) == 0
    end

    def xy_add(x, y)
      self.class.lookup([@x.value + x, @y.value + y])
    end
    private :xy_add

    def vector_add(vector)
      xy_add(vector.x, vector.y)
    end

    # 上下左右 -1 +1 -1 +1 に進んだ位置を返す (white側の場合も考慮する)
    # 2つ進んだ位置などを一発で調べたいときに使う
    # なるべく使うな
    def move_to_xy(location, x, y)
      xy_add(x * location.sign_dir, y * location.sign_dir)
    end

    ################################################################################ location から見た上下左右に寄せた位置を返す

    def move_to_bottom_edge(location)
      self.class.fetch([x, location.bottom])
    end

    def move_to_top_edge(location)
      self.class.fetch([x, location.top])
    end

    def move_to_left_edge(location)
      self.class.fetch([location.left, y])
    end

    def move_to_right_edge(location)
      self.class.fetch([location.right, y])
    end

    ################################################################################ location から見た情報を返す

    Dimension::DimensionColumn::DELEGATE_METHODS.each do |name|
      define_method(name) do |location|
        @x.white_then_flip(location).public_send(name)
      end
    end

    Dimension::DimensionRow::DELEGATE_METHODS.each do |name|
      define_method(name) do |location|
        @y.white_then_flip(location).public_send(name)
      end
    end

    ################################################################################
  end
end
