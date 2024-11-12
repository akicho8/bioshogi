# frozen-string-literal: true

# $counter = Hash.new(0)

module Bioshogi
  module Dimension
    class Base
      DEFAULT = 9

      class_attribute :dimension_size, default: DEFAULT

      attr_reader :value

      class << self
        def default_size?
          dimension_size == DEFAULT
        end

        def fetch(value)
          lookup(value) or raise SyntaxDefact, "座標が読み取れません : #{value.inspect}"
        end

        def lookup(value)
          table[value]
        end

        def size_reset(v)
          self.dimension_size = v
          cache_clear
        end

        def cache_clear
          @char_infos  = nil
          @table       = nil
          @value_range = nil
        end

        def table
          @table ||= char_infos.each.with_index.inject({}) { |a, (e, i)|
            object = new(i).freeze
            a.merge({
                object           => object,
                i                => object,
                e.number_kanji   => object,
                e.hankaku_number => object,
                e.number_zenkaku => object,
              })
          }.freeze
        end

        # # 幅
        def value_range
          @value_range ||= 0...char_infos.size
        end
      end

      private_class_method :new

      def initialize(value)
        @value = value

        # freeze するためメモ化するなら @func ||= xxx ではなく @cache[:func] ||= xxx とする
        @cache = {}
      end

      # def cache_clear
      #   @cache.clear
      # end

      delegate *[
        :key,
        :number_kanji,
        :number_zenkaku,
        :hankaku_number,
      ], to: :char_info

      def char_info
        self.class.char_infos[value]
      end

      def yomiage
        Yomiage::NumberInfo.fetch(key).yomiage
      end

      def flip
        self.class.fetch(dimension_size.pred - value)
      end

      # FIXME: ここでキャッシュするとテストがこける
      def white_then_flip(location)
        location = Location[location]
        if location.key == :white
          flip
        else
          self
        end

        # location2 = Location[location]
        # real = yield_self do
        #   if location2.key == :white
        #     flip
        #   else
        #     self
        #   end
        # end
        #
        #
        # location2 = Location[location]
        # real = @cache["white_then_flip_#{key}_#{location2.key}"] ||= yield_self do
        #   if location2.key == :white
        #     flip
        #   else
        #     self
        #   end
        # end
        #
        # $counter["#{key}_#{location2.key}_#{real.key}"] += 1
        # real
      end

      def ==(other)
        self.class == other.class && value == other.value
      end

      def <=>(other)
        value <=> other.value
      end

      def eql?(other)
        self.class == other.class && value == other.value
      end

      def hash
        self.class.hash ^ value.hash
      end

      def inspect
        "#<#{self.class.name}:#{object_id} #{name.inspect} #{value}>"
      end
    end
  end
end
