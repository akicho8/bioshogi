# frozen-string-literal: true

module Bioshogi
  module Dimension
    class CharInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: "1",  kanji_number: "一", zenkaku_number: "１", },
        { key: "2",  kanji_number: "二", zenkaku_number: "２", },
        { key: "3",  kanji_number: "三", zenkaku_number: "３", },
        { key: "4",  kanji_number: "四", zenkaku_number: "４", },
        { key: "5",  kanji_number: "五", zenkaku_number: "５", },
        { key: "6",  kanji_number: "六", zenkaku_number: "６", },
        { key: "7",  kanji_number: "七", zenkaku_number: "７", },
        { key: "8",  kanji_number: "八", zenkaku_number: "８", },
        { key: "9",  kanji_number: "九", zenkaku_number: "９", },
      ]

      def hankaku_number
        key.to_s
      end
    end
  end
end
