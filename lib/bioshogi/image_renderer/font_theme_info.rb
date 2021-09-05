module Bioshogi
  class ImageRenderer
    class FontThemeInfo
      include ApplicationMemoryRecord
      memory_record [
        {
          :key          => :gothic_type1,
          :font_regular => "#{__dir__}/../assets/fonts/RictyDiminished-Regular.ttf",
          :font_bold    => "#{__dir__}/../assets/fonts/RictyDiminished-Bold.ttf",
        },
        {
          :key          => :mincho_type1,
          :font_regular => "/System/Library/Fonts/ヒラギノ明朝 ProN.ttc",
          :font_bold    => nil,
        },
      ]

      def to_params
        {
          :font_regular => font_regular,
          :font_bold    => font_bold,
        }
      end
    end
  end
end
