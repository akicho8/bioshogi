# frozen-string-literal: true

module Bioshogi
  module Dimension
    class Base
      class_attribute :dimension
      self.dimension = 9

      attr_reader :value

      class << self
        def fetch(value)
          lookup(value) or raise SyntaxDefact, "座標が読み取れません : #{value.inspect}"
        end

        def lookup(value)
          table[value]
        end

        def dimension_set(v)
          self.dimension = v
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
                e.number_hankaku => object,
                e.number_zenkaku => object,
              })
          }.freeze
        end

        # 幅
        def value_range
          @value_range ||= 0...char_infos.size
        end
      end

      private_class_method :new

      def initialize(value)
        @value = value
      end

      delegate *[
        :key,
        :number_kanji,
        :number_zenkaku,
        :number_hankaku,
      ], to: :char_info

      def char_info
        self.class.char_infos[@value]
      end

      def yomiage
        YomiageNumberInfo.fetch(key).yomiage
      end

      def flip
        self.class.fetch(self.class.char_infos.size - 1 - @value)
      end

      def ==(other)
        self.class == other.class && value == other.value
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
    end
  end
end
