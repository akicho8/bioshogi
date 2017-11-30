# frozen-string-literal: true
#
# 一次元座標管理
#

require "active_support/core_ext/array/access" # for seconds

module Bushido
  module Position
    class << self
      # 一時的に盤面のサイズを変更する(テスト用)
      #
      #   before do
      #     @size_save = Board.size_change([3, 5])
      #   end
      #   after do
      #     Board.size_change(@size_save)
      #   end
      #
      def size_change(wsize, &block)
        save_value = [Hpos.board_size, Vpos.board_size]
        Hpos.board_size_reset(wsize.first)
        Vpos.board_size_reset(wsize.second)
        if block_given?
          begin
            yield
          ensure
            Hpos.board_size_reset(save_value.first)
            Vpos.board_size_reset(save_value.second)
          end
        else
          save_value
        end
      end

      # サイズ毎のクラスがいるかも
      # かなりやっつけの仮
      def size_type
        key = [Hpos.board_size, Vpos.board_size]
        {
          [5, 5] => :x55,
          [9, 9] => :board_size_9x9,
        }[key]
      end

      # 一時的に成れない状況にする
      def disable_promotable
        begin
          _promotable_size = Vpos._promotable_size
          Vpos._promotable_size = nil
          yield
        ensure
          Vpos._promotable_size = _promotable_size
        end
      end
    end

    class Base
      class_attribute :board_size
      self.board_size = 9

      attr_reader :value
      private_class_method :new

      class << self
        # 座標をパースする
        # @example
        #   Position::Hpos.parse("１").name # => "1"
        def parse(arg)
          if arg.kind_of?(Base)
            return arg
          end

          if arg.blank?
            raise PositionSyntaxError, "引数がありません"
          end

          if arg.kind_of?(String)
            v = units_set[arg]
            v or raise PositionSyntaxError, "#{arg.inspect} が #{units} の中にありません"
          else
            v = arg
          end

          @instance ||= {}
          @instance[v] ||= new(v)
        end

        def board_size_reset(v)
          self.board_size = v

          @instance = nil
          @units = nil
          @units_set = nil
          @value_range = nil
        end

        # 全角の文字配列
        def units
          @units ||= _units.chars.to_a.send(_arrow, board_size)
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

      # 座標が盤上か？
      def valid?
        self.class.value_range.cover?(@value)
      end

      # 名前
      # @example
      #   Position::Vpos.parse("一").name # => "一"
      def name
        @name ||= self.class.units[@value]
      end

      # 数字表記
      # @example
      #   Position::Vpos.parse("一").number_format # => "1"
      def number_format
        name
      end

      # 座標反転
      # @example
      #   Position::Hpos.parse("1").reverse.name # => "9"
      def reverse
        @reverse ||= self.class.parse(self.class.units.size - 1 - @value)
      end

      # インスタンスが異なっても同じ座標なら同じ
      def ==(other)
        self.class == other.class && @value == other.value
      end

      def inspect
        "#<#{self.class.name}:#{object_id} #{name.inspect} #{@value}>"
      end

      # 成れるか？
      # @example
      #   Point.parse("１三").promotable?(:black) # => true
      #   Point.parse("１四").promotable?(:black) # => false
      def promotable?(location)
        v = self
        if location.white?
          v = v.reverse
        end
        if _promotable_size
          v.value < _promotable_size
        end
      end
    end

    class Hpos < Base
      cattr_accessor(:_units)           { "９８７６５４３２１" }
      cattr_accessor(:_arrow)           { :last } # ←左方向に増加
      cattr_accessor(:_promotable_size) { nil }

      def self.parse(arg)
        if arg.kind_of?(String)
          arg = arg.tr("1-9", "１-９")
          arg = arg.tr("一二三四五六七八九", "１-９")
        end
        super
      end

      def number_format
        name.tr("１-９", "1-9")
      end
    end

    class Vpos < Base
      cattr_accessor(:_units)           { "一二三四五六七八九" }
      cattr_accessor(:_arrow)           { :first } # 右方向に増加→
      cattr_accessor(:_promotable_size) { 3 }      # 相手の陣地の成れる縦幅

      # "(52)" の "2" に対応するため
      def self.parse(arg)
        if arg.kind_of?(String)
          arg = arg.tr("1-9１-９", "#{_units}#{_units}")
        end
        super
      end

      def number_format
        # "一-九" は文字コード順ではないので指定できない
        super.tr(_units, "1-9")
      end
    end
  end
end
