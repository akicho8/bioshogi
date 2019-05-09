module Bioshogi
  module KanjiNumber
    extend self

    # KanjiNumber.kanji_to_number_string("")         # => ""
    # KanjiNumber.kanji_to_number_string("歩")       # => "歩"
    # KanjiNumber.kanji_to_number_string("歩〇")     # => "歩0"
    # KanjiNumber.kanji_to_number_string("歩九")     # => "歩9"
    # KanjiNumber.kanji_to_number_string("歩十")     # => "歩10"
    # KanjiNumber.kanji_to_number_string("歩十〇")   # => "歩10"
    # KanjiNumber.kanji_to_number_string("歩十一")   # => "歩11"
    # KanjiNumber.kanji_to_number_string("歩十九")   # => "歩19"
    # KanjiNumber.kanji_to_number_string("歩二十")   # => "歩20"
    # KanjiNumber.kanji_to_number_string("歩二十〇") # => "歩20"
    # KanjiNumber.kanji_to_number_string("歩二十一") # => "歩21"
    #
    # https://qiita.com/alfa/items/24611f664949709f530d
    # http://d.hatena.ne.jp/rubikitch/20081201/1228142072
    def kanji_to_number_string(str)
      s = str.tr(kanji_numbers, "0-9")
      s.gsub(/(?<number>\d+)?(?<unit>[#{units.values.join}])(?<rest>\d+)?/o) do |s| # ブロック引数に md がきてほしい
        md = Regexp.last_match
        digit = units_invert.fetch(md[:unit])
        v = (md[:number] || 1).to_i * digit
        v + md[:rest].to_i
      end
    end

    # KanjiNumber.integer_to_kanji(0)                # => "〇"
    # KanjiNumber.integer_to_kanji(1)                # => "一"
    # KanjiNumber.integer_to_kanji(10)               # => "十"
    # KanjiNumber.integer_to_kanji(12)               # => "十二"
    # KanjiNumber.integer_to_kanji(2)                # => "二"
    # KanjiNumber.integer_to_kanji(23)               # => "二十三"
    def integer_to_kanji(v)
      out = []
      units.each do |d, s|
        v, r = v.divmod(d)
        case
        when v == 1
          out << s
        when v >= 2
          out << kanji_numbers[v] + s
        end
        v = r
      end
      if v == 0 && out.empty?
        out << kanji_numbers[v]   # ここをはずせば 0 のとき表示しない。「零」などに変更も可
      elsif v >= 1
        out << kanji_numbers[v]
      end
      out.join
    end

    private

    def kanji_numbers
      "〇一二三四五六七八九"
    end

    def units
      @units ||= { 10 => "十" }
    end

    def units_invert
      @units_invert ||= units.invert
    end
  end

  if $0 == __FILE__
    KanjiNumber.kanji_to_number_string("")         # => ""
    KanjiNumber.kanji_to_number_string("歩")       # => "歩"
    KanjiNumber.kanji_to_number_string("歩〇")     # => "歩0"
    KanjiNumber.kanji_to_number_string("歩九")     # => "歩9"
    KanjiNumber.kanji_to_number_string("歩十")     # => "歩10"
    KanjiNumber.kanji_to_number_string("歩十〇")   # => "歩10"
    KanjiNumber.kanji_to_number_string("歩十一")   # => "歩11"
    KanjiNumber.kanji_to_number_string("歩十九")   # => "歩19"
    KanjiNumber.kanji_to_number_string("歩二十")   # => "歩20"
    KanjiNumber.kanji_to_number_string("歩二十〇") # => "歩20"
    KanjiNumber.kanji_to_number_string("歩二十一") # => "歩21"

    KanjiNumber.integer_to_kanji(0)                # => "〇"
    KanjiNumber.integer_to_kanji(1)                # => "一"
    KanjiNumber.integer_to_kanji(10)               # => "十"
    KanjiNumber.integer_to_kanji(12)               # => "十二"
    KanjiNumber.integer_to_kanji(2)                # => "二"
    KanjiNumber.integer_to_kanji(23)               # => "二十三"
  end
end
