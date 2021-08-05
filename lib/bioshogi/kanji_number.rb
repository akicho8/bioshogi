require "active_support/all"

module Bioshogi
  module KanjiNumber
    extend self

    mattr_accessor(:unit_size)     { 6 } # 2なら百まで。6なら「兆」まで対応。100までで良いなら2にしとくと気持ち程度速い
    mattr_accessor(:add_one_level) { 4 } # 万を超えたら「万」ではなく「一万」となる

    mattr_accessor(:kanji_table) { "〇一二三四五六七八九" }
    mattr_accessor(:unit_table)  { "十百千万憶兆"         }

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
      s = str.tr(kanji_table, "0-9")
      unit_size.times do |i|
        s = s.gsub(/(?<number>\d+)?(?<unit>#{unit_table[i]})(?<rest>\d+)?/) do |s| # ブロック引数に md がきてほしい
          md = Regexp.last_match
          v = (md[:number] || 1).to_i * 10**(i+1)
          v + md[:rest].to_i
        end
      end
      s
    end

    # KanjiNumber.integer_to_kanji(0)                # => "〇"
    # KanjiNumber.integer_to_kanji(1)                # => "一"
    # KanjiNumber.integer_to_kanji(10)               # => "十"
    # KanjiNumber.integer_to_kanji(12)               # => "十二"
    # KanjiNumber.integer_to_kanji(2)                # => "二"
    # KanjiNumber.integer_to_kanji(23)               # => "二十三"
    def integer_to_kanji(v)
      out = []
      unit_size.step(by: -1, to: 1).each do |x|
        s = unit_table[x - 1]
        d = 10**x
        q, r = v.divmod(d)
        case
        when q == 1
          if x >= add_one_level
            out << kanji_table[q] + s
          else
            out << s
          end
        when q >= 2
          out << kanji_table[q] + s
        end
        v = r
      end
      if v == 0 && out.empty?
        out << kanji_table[v]   # ここをはずせば 0 のとき表示しない。「零」などに変更も可
      elsif v >= 1
        out << kanji_table[v]
      end
      out.join
    end
  end

  if $0 == __FILE__
    KanjiNumber.kanji_to_number_string("")               # => ""
    KanjiNumber.kanji_to_number_string("歩")             # => "歩"
    KanjiNumber.kanji_to_number_string("歩〇")           # => "歩0"
    KanjiNumber.kanji_to_number_string("歩九")           # => "歩9"
    KanjiNumber.kanji_to_number_string("歩十")           # => "歩10"
    KanjiNumber.kanji_to_number_string("歩十〇")         # => "歩10"
    KanjiNumber.kanji_to_number_string("歩十一")         # => "歩11"
    KanjiNumber.kanji_to_number_string("歩十九")         # => "歩19"
    KanjiNumber.kanji_to_number_string("歩二十")         # => "歩20"
    KanjiNumber.kanji_to_number_string("歩二十〇")       # => "歩20"
    KanjiNumber.kanji_to_number_string("歩二十一")       # => "歩21"
    KanjiNumber.kanji_to_number_string("歩百二十三")     # => "歩123"
    KanjiNumber.kanji_to_number_string("歩千二百三十四") # => "歩1234"

    KanjiNumber.kanji_to_number_string("歩十")           # => "歩10"
    KanjiNumber.kanji_to_number_string("歩百")           # => "歩100"
    KanjiNumber.kanji_to_number_string("歩千")           # => "歩1000"
    KanjiNumber.kanji_to_number_string("歩1万")          # => "歩10000"
    KanjiNumber.kanji_to_number_string("歩1憶")          # => "歩100000"
    KanjiNumber.kanji_to_number_string("歩1兆")          # => "歩1000000"

    KanjiNumber.integer_to_kanji(0)                      # => "〇"
    KanjiNumber.integer_to_kanji(1)                      # => "一"
    KanjiNumber.integer_to_kanji(10)                     # => "十"
    KanjiNumber.integer_to_kanji(12)                     # => "十二"
    KanjiNumber.integer_to_kanji(2)                      # => "二"
    KanjiNumber.integer_to_kanji(23)                     # => "二十三"
    KanjiNumber.integer_to_kanji(123)                    # => "百二十三"
    KanjiNumber.integer_to_kanji(120)                    # => "百二十"
    KanjiNumber.integer_to_kanji(100)                    # => "百"
    KanjiNumber.integer_to_kanji(1000)                   # => "千"
    KanjiNumber.integer_to_kanji(10000)                  # => "一万"
    KanjiNumber.integer_to_kanji(100000)                 # => "一憶"
    KanjiNumber.integer_to_kanji(1000000)                # => "一兆"
  end
end
