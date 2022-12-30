# frozen-string-literal: true

module Bioshogi
  module Dimension
    class PlaceY < Base
      cattr_accessor(:promotable_depth) { 3 }      # 相手の陣地の成れる縦幅

      class << self
        def char_infos
          @char_infos ||= CharInfo.take(dimension)
        end

        # 一時的に成れない状況にする
        def promotable_disabled(&block)
          old_value = promotable_depth
          PlaceY.promotable_depth = nil
          if block_given?
            begin
              yield
            ensure
              self.promotable_depth = old_value
            end
          else
            old_value
          end
        end
      end

      def name
        char_info.number_kanji
      end

      def to_sfen
        ("a".ord + value).chr
      end

      # 人間向けの数字で 68 なら 8
      def to_human_int
        value + 1
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
        if promotable_depth
          v.value < promotable_depth
        end
      end
    end
  end
end
