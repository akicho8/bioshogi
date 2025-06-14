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
          Dimension::Row.dimension_size.times.flat_map { |row|
            Dimension::Column.dimension_size.times.collect { |column|
              self[[column, row]]
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

        column = nil
        row = nil

        case value
        when Array
          a, b = value
          column = Dimension::Column.lookup(a)
          row = Dimension::Row.lookup(b)
        when String
          a, b = value.chars
          column = Dimension::Column.lookup(a)
          row = Dimension::Row.lookup(b)
        else
          if respond_to?(:to_a)
            return lookup(value.to_a)
          end
        end

        # 座標は最大で99なのでインスタンスを使いまわす
        # ただしグローバルな寸法が変わると不整合な状態になるため cache_clear を適切に呼ばないといけない
        if column && row
          @cache ||= {}
          @cache[column] ||= {}
          @cache[column][row] ||= new(column, row)
        end
      end

      def [](value)
        lookup(value)
      end

      def zero
        fetch([0, 0])
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

    attr_accessor :column, :row

    # for Soldier
    DELEGATE_METHODS = [
      *Dimension::Column::DELEGATE_METHODS,
      *Dimension::Row::DELEGATE_METHODS,

      :relative_move_to,
      :move_to_xy,
      :king_default_place?,

      :move_to_bottom_edge,
      :move_to_top_edge,
      :move_to_left_edge,
      :move_to_right_edge,
    ]

    def initialize(column, row)
      @column = column
      @row = row
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

    # "６八銀" なら {column:6, row:8}
    # キャッシュすると2倍速くなる
    def to_human_h
      @cache[:to_human_h] ||= Hash[[:column, :row].zip(to_human_int)]
    end

    # ほぼキャッシュ効果なし。それどころか少し遅くなる。ただ配列を再生成しないのでこれでいいことにする。
    def to_a
      @cache[:to_a] ||= [@column, @row]
    end

    ################################################################################

    # 180度回転
    def flip
      @cache[:flip] ||= self.class.fetch(to_a.collect(&:flip))
    end

    # column座標のみ反転
    def flop
      @cache[:flop] ||= self.class.fetch([@column.flip, @row])
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

    # 距離を返す (ユークリッド距離ではなく升目の移動ステップ数)
    def distance(other)
      column.distance(other.column) + row.distance(other.row)
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
      self.class.lookup([@column.value + x, @row.value + y])
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
      self.class.fetch([column, location.bottom])
    end

    def move_to_top_edge(location)
      self.class.fetch([column, location.top])
    end

    def move_to_left_edge(location)
      self.class.fetch([location.left, row])
    end

    def move_to_right_edge(location)
      self.class.fetch([location.right, row])
    end

    ################################################################################ location から見た情報を返す

    Dimension::Column::DELEGATE_METHODS.each do |name|
      define_method(name) do |location|
        @column.white_then_flip(location).public_send(name)
      end
    end

    Dimension::Row::DELEGATE_METHODS.each do |name|
      define_method(name) do |location|
        @row.white_then_flip(location).public_send(name)
      end
    end

    ################################################################################
  end
end
