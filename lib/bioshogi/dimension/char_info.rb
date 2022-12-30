# frozen-string-literal: true

module Bioshogi
  module Dimension
    class CharInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: "1",  number_kanji: "一", number_zenkaku: "１", },
        { key: "2",  number_kanji: "二", number_zenkaku: "２", },
        { key: "3",  number_kanji: "三", number_zenkaku: "３", },
        { key: "4",  number_kanji: "四", number_zenkaku: "４", },
        { key: "5",  number_kanji: "五", number_zenkaku: "５", },
        { key: "6",  number_kanji: "六", number_zenkaku: "６", },
        { key: "7",  number_kanji: "七", number_zenkaku: "７", },
        { key: "8",  number_kanji: "八", number_zenkaku: "８", },
        { key: "9",  number_kanji: "九", number_zenkaku: "９", },
      ]

      def number_hankaku
        key.to_s
      end
    end
  end
end
