# frozen-string-literal: true

module Bioshogi
  module Dimension
    class Base
      DEFAULT = 9
      CACHE_ENABLE = true

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
