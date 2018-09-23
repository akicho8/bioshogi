# frozen-string-literal: true

module Warabi
  module Dimension
    class << self
      # 一時的に盤面のサイズを変更する(テスト用)
      #
      #   before do
      #     @size_save = Board.dimensiton_change([3, 5])
      #   end
      #   after do
      #     Board.dimensiton_change(@size_save)
      #   end
      #
      def dimensiton_change(wsize, &block)
        save_value = [Yplace.dimension, Xplace.dimension]
        h, v = wsize
        Yplace.board_size_reset(h)
        Xplace.board_size_reset(v)
        if block_given?
          begin
            yield
          ensure
            h, v = save_value
            Yplace.board_size_reset(h)
            Xplace.board_size_reset(v)
          end
        else
          save_value
        end
      end

      # サイズ毎のクラスがいるかも
      # かなりやっつけの仮
      def size_type
        key = [Yplace.dimension, Xplace.dimension]
        {
          [5, 5] => :x55,
          [9, 9] => :board_size_9x9,
        }[key]
      end

      # 一時的に成れない状況にする
      def promotable_disable
        _promotable_size = Xplace._promotable_size
        Xplace._promotable_size = nil
        if block_given?
          begin
            yield
          ensure
            Xplace._promotable_size = _promotable_size
          end
        else
          _promotable_size
        end
      end
    end

    class Base
      class_attribute :dimension
      self.dimension = 9

      attr_reader :value
      private_class_method :new

      class << self
        def fetch(value)
          lookup(value) or raise SyntaxDefact, "座標が読み取れません : #{value.inspect}"
        end

        def lookup(value)
          if value.kind_of?(Base)
            return value
          end
          if value.kind_of?(String)
            value = units_set[value]
          end
          if value
            @instance ||= {}
            @instance[value] ||= new(value).freeze
          end
        end

        def board_size_reset(v)
          self.dimension = v

          @instance = nil
          @units = nil
          @units_set = nil
          @value_range = nil
        end

        # 全角の文字配列
        def units
          @units ||= _units.chars.to_a.send(_arrow, dimension)
        end

        def units_set
          @units_set ||= units.each.with_index.inject({}) {|a, (e, i)| a.merge(e => i) }
        end

        # 幅
        def value_range
          @value_range ||= 0...units.size
        end
      end

      def initialize(value)
        @value = value
      end

      def valid?
        self.class.value_range.cover?(@value)
      end

      def name
        self.class.units[@value]
      end

      def number_format
        name
      end

      def kifuyomi
        NumberInfo.fetch(number_format).yomikata
      end

      def to_sfen
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      def flip
        self.class.fetch(self.class.units.size - 1 - @value)
      end

      # インスタンスが異なっても同じ座標なら同じ
      def ==(other)
        self.class == other.class && @value == other.value
      end

      def <=>(other)
        @value <=> other.value
      end

      def eql?(other)
        self.class == other.class && value == other.value
      end

      def hash
        self.class.hash ^ value.hash
      end

      def inspect
        "#<#{self.class.name}:#{object_id} #{name.inspect} #{@value}>"
      end

      # 成れるか？
      # @example
      #   Place.fetch("１三").promotable?(:black) # => true
      #   Place.fetch("１四").promotable?(:black) # => false
      def promotable?(location)
        v = self
        if location.white?
          v = v.flip
        end
        if _promotable_size
          v.value < _promotable_size
        end
      end
    end

    class Yplace < Base
      cattr_accessor(:_units)           { "９８７６５４３２１" }
      cattr_accessor(:_arrow)           { :last } # ←左方向に増加
      cattr_accessor(:_promotable_size) { nil }

      def self.lookup(value)
        if value.kind_of?(String)
          value = value.tr("1-9一二三四五六七八九", "１-９１-９")
        end
        super
      end

      def number_format
        name.tr("１-９", "1-9")
      end

      def to_sfen
        (self.class.units.size - @value).to_s
      end
    end

    class Xplace < Base
      cattr_accessor(:_units)           { "一二三四五六七八九" }
      cattr_accessor(:_arrow)           { :first } # 右方向に増加→
      cattr_accessor(:_promotable_size) { 3 }      # 相手の陣地の成れる縦幅

      # "(52)" の "2" に対応するため
      def self.lookup(value)
        if value.kind_of?(String)
          value = value.tr("1-9１-９", "#{_units}#{_units}")
        end
        super
      end

      def number_format
        super.tr(_units, "1-9") # 文字コード順ではないため "一-九" とは書けない
      end

      def to_sfen
        ("a".ord + value).chr
      end
    end
  end
end
