module Bioshogi
  module ScreenImage
    class FontThemeInfo
      include ApplicationMemoryRecord
      memory_record [
        # ../assets/fonts
        # NOTE: ricty_sans で位置調整しているため他にするとずれる。他に切り替えるには位置調整をそれぞれのフォントで行わないといけない
        { key: :ricty_sans,           font_regular: "RictyDiminished-Regular.ttf", font_bold: "RictyDiminished-Bold.ttf", },
        { key: :noto_seif,            font_regular: "NotoSerifJP-Regular.otf",     font_bold: "NotoSerifJP-Bold.otf",     },
        { key: :mplus_rounded1c_sans, font_regular: "MPLUSRounded1c-Regular.ttf",  font_bold: "MPLUSRounded1c-Bold.ttf",  },
        { key: :noto_sans,            font_regular: "NotoSansJP-Regular.otf",      font_bold: "NotoSansJP-Bold.otf",      },
        { key: :yusei_magic_sans,     font_regular: "YuseiMagic-Regular.ttf",      font_bold: nil,                        },
      ]

      def to_params
        {
          :font_regular => font_regular,
          :font_bold    => font_bold,
        }
      end

      def font_regular
        if v = super
          ASSETS_DIR.join("fonts/#{v}")
        end
      end

      def font_bold
        if v = super
          ASSETS_DIR.join("fonts/#{v}")
        end
      end
    end
  end
end
