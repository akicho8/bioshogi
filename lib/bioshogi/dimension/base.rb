# frozen-string-literal: true

module Bioshogi
  module Dimension
    class Base
      DEFAULT = 9
      CACHE_ENABLE = true # 結局のところ white_then_flip でキャッシュは必要ないが、キャッシュすることで Place.cache_clear の適切な使用がテストできる

      class_attribute :dimension_size, default: DEFAULT

      attr_reader :value

      class << self
        ################################################################################

        def first
          fetch(0)
        end

        def last
          fetch(dimension_size.pred)
        end

        def half
          fetch(dimension_size / 2)
        end

        def default_size?
          dimension_size == DEFAULT
        end

        def size_reset(v)
          self.dimension_size = v
          cache_clear
        end

        ################################################################################

        def fetch(value)
          table.fetch(value) do
            raise SyntaxDefact, "座標が読み取れません : #{value.inspect}"
          end
        end

        def lookup(value)
          table[value]
        end

        def table
          @table ||= char_infos.each.with_index.inject({}) { |a, (e, i)|
            object = new(i)
            a.merge({
                object           => object,
                i                => object,
                e.number_kanji   => object,
                e.hankaku_number => object,
                e.number_zenkaku => object,
              })
          }.freeze
        end

        ################################################################################

        # 幅
        def value_range
          @value_range ||= 0...char_infos.size
        end

        def cache_clear
          @char_infos  = nil
          @table       = nil
          @value_range = nil
        end
      end

      private_class_method :new

      def initialize(value)
        @value = value

        # freeze するためメモ化するなら @func ||= xxx ではなく @cache[:func] ||= xxx とする
        @cache = {}

        freeze
      end

      def cache_clear
        @cache.clear
      end

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

      ################################################################################

      def flip
        @cache[:flip] ||= self.class.fetch(dimension_size.pred - value)
      end

      def white_then_flip(location)
        if CACHE_ENABLE
          location = Location[location]
          @cache["white_then_flip/#{location.key}"] ||= yield_self do
            if location.key == :white
              flip
            else
              self
            end
          end
        else
          location = Location[location]
          if location.key == :white
            flip
          else
            self
          end
        end
      end

      ################################################################################

      def distance(other)
        if self.class != other.class
          raise ArgumentError, "同じクラスはありません : #{other}"
        end

        (value - other.value).abs
      end

      def distance_from_half
        distance(self.class.half)
      end

      ################################################################################

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

      ################################################################################
    end
  end
end
