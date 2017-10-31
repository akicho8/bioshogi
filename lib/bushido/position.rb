#
# 一次元座標管理
#
module Bushido
  module Position
    module Base
      extend ActiveSupport::Concern

      included do
        class_attribute :size
        self.size = 9

        attr_reader :value
        private_class_method :new
      end

      module ClassMethods
        # 座標をパースする
        # @example
        #   Position::Hpos.parse("１").name # => "1"
        def parse(arg)
          case arg
          when String, NilClass
            v = units.find_index{|e|e == arg}
            v or raise PositionSyntaxError, "#{arg.inspect} が #{units} の中にない"
          when Base
            v = arg.value
          else
            v = arg
          end
          new(v)
        end

        # 幅
        def value_range
          (0...units.size)
        end

        def units(options = {})
          orig_units(options).send(_arrow, size)
        end

        def orig_units(options = {})
          (options[:zenkaku] ? _zenkaku_units : _units).chars.to_a
        end

        # # 右上からのインデックスで参照できるように返す
        # def units_from_right_top(index, options = {})
        #   if _arrow == :last
        #     units.reverse
        #   else
        #     units
        #   end
        # end

      end

      def initialize(value)
        @value = value
      end

      # 座標が盤上か？
      def valid?
        self.class.value_range.include?(@value)
      end

      # 名前
      # @example
      #   Position::Vpos.parse("一").name # => "一"
      def name
        self.class.units[@value]
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
        self.class.parse(self.class.units.size - 1 - @value)
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

    class Hpos
      include Base
      cattr_accessor(:_units)             {"987654321"}
      cattr_accessor(:_zenkaku_units)     {"９８７６５４３２１"}
      cattr_accessor(:_arrow)             {:last}
      cattr_accessor(:_promotable_size) {nil}
      cattr_accessor(:regexp)             {/[１-９1-9]/o}

      # "５五" の全角 "５" に対応するため
      def self.parse(arg)
        if String === arg && arg.match(/[１-９]/)
          arg = arg.tr("１-９", _units.reverse)
        end
        super
      end
    end

    class Vpos
      include Base
      cattr_accessor(:_units)             {"一二三四五六七八九"}
      cattr_accessor(:_zenkaku_units)     {"一二三四五六七八九"}
      cattr_accessor(:_arrow)             {:first}
      cattr_accessor(:_promotable_size) {3}
      cattr_accessor(:regexp)             {/[一二三四五六七八九1-9]/o}

      # "(52)" の "2" に対応するため
      def self.parse(arg)
        if String === arg && arg.match(/\d/)
          arg = arg.tr("1-9", _units)
        end
        super
      end

      def number_format
        super.tr(self.class._units, "1-9")
      end
    end
  end
end
