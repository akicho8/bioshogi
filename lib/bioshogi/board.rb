# frozen-string-literal: true

module Bioshogi
  module Board
    class << self
      def new(...)
        Basic.new(...)
      end

      # 指定の柿木図面から手合割を逆算する
      def guess_preset_info(str, options = {})
        create_by_shape(str).preset_info(options)
      end

      def create_by_shape(str)
        new.tap { |e| e.placement_from_shape(str) }
      end

      def create_by_human(str)
        new.tap { |e| e.placement_from_human(str) }
      end

      def create_by_preset(key)
        new.tap { |e| e.placement_from_preset(key) }
      end
    end
  end
end
