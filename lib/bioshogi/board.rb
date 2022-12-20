# frozen-string-literal: true

module Bioshogi
  module Board
    class << self
      def new(*args, &block)
        Basic.new(*args, &block)
      end

      # 指定の柿木図面から手合割を逆算する
      def guess_preset_info(shape, options = {})
        board = new
        board.placement_from_shape(shape)
        board.preset_info(options)
      end

      def create_by_shape(key)
        new.tap do |board|
          board.placement_from_shape(key)
        end
      end

      def create_by_human(key)
        new.tap do |board|
          board.placement_from_human(key)
        end
      end

      def create_by_preset(key)
        new.tap do |board|
          board.placement_from_preset(key)
        end
      end
    end
  end
end
