module Bioshogi
  class ImageRenderer
    class PaletteInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: "主用駒色", hsl: [ 43, 100, 81], },
        { key: "主用朱色", hsl: [358, 84, 60],  },
      ]

      def to_color
        @to_color ||= Color::HSL.new(*hsl)
      end
    end
  end
end
