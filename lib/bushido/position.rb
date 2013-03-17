# -*- coding: utf-8 -*-
#
# 一次元座標管理
#
module Bushido
  module Position
    class Base
      cattr_accessor(:ridge_length){9}

      attr_reader :value
      private_class_method :new

      # 座標をパースする
      #   Position::Hpos.parse("１").name # => "1"
      def self.parse(arg)
        case arg
        when String, NilClass
          v = units.find_index{|e|e == arg}
          v or raise PositionSyntaxError, "#{arg.inspect} が #{units} の中にありません"
        when Base
          v = arg.value
        else
          v = arg
        end
        new(v)
      end

      # 幅
      def self.value_range
        (0...units.size)
      end

      def self.units(options = {})
        (options[:zenkaku] ? _zenkaku_units : _units).chars.to_a.send(_arrow, ridge_length)
      end

      # # 右上からのインデックスで参照できるように返す
      # def self.units_from_right_top(index, options = {})
      #   if _arrow == :last
      #     units.reverse
      #   else
      #     units
      #   end
      # end

      def initialize(value)
        @value = value
      end

      # 座標が盤上か？
      def valid?
        self.class.value_range.include?(@value)
      end

      # 名前
      #   Position::Vpos.parse("一").name # => "一"
      def name
        self.class.units[@value]
      end

      # 数字表記
      #   Position::Vpos.parse("一").number_format # => "1"
      def number_format
        name
      end

      # 座標反転
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
      #   Point.parse("１三").promotable?(:black) # => true
      #   Point.parse("１四").promotable?(:black) # => false
      def promotable?(location)
        v = self
        if location.white?
          v = v.reverse
        end
        if _promotable_length
          v.value < _promotable_length
        end
      end
    end

    class Hpos < Base
      cattr_accessor(:_units)             {"987654321"}
      cattr_accessor(:_zenkaku_units)     {"９８７６５４３２１"}
      cattr_accessor(:_arrow)             {:last}
      cattr_accessor(:_promotable_length) {nil}

      # "５五" の全角 "５" に対応するため
      def self.parse(arg)
        if String === arg && arg.match(/[１-９]/)
          arg = arg.tr("１-９", units.reverse.join)
        end
        super
      end
    end

    class Vpos < Base
      cattr_accessor(:_units)             {"一二三四五六七八九"}
      cattr_accessor(:_zenkaku_units)     {"一二三四五六七八九"}
      cattr_accessor(:_arrow)             {:first}
      cattr_accessor(:_promotable_length) {3}

      # "(52)" の "2" に対応するため
      def self.parse(arg)
        if String === arg && arg.match(/\d/)
          arg = arg.tr("1-9", units.join)
        end
        super
      end

      def number_format
        super.tr(self.class.units.join, "1-9")
      end
    end
  end
end
