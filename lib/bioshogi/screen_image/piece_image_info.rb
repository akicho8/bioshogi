module Bioshogi
  module ScreenImage
    class PieceImageInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: :portella, name: "Portella", ext_name: "png", default_scale: 0.95, custom_shadow_support: false, },
        { key: :nureyon,  name: "ぬれよん", ext_name: "png", default_scale: 0.80, custom_shadow_support: true,  },
      ]

      class << self
        def lookup(v)
          if v
            v = v.downcase
            super
          end
        end
      end

      # 駒の種類をプレフィクスにした駒の部分パスを返す
      # "nureyon/BP0"
      def piece_path(soldier)
        "#{key}/#{soldier.image_basename}"
      end
    end
  end
end
