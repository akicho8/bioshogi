require "active_support/all"

module Bioshogi
  module KanjiNumber
    extend self

    # 100までで良いなら2にしとくと気持ち程度速くなる
    # 2なら百まで
    # 3なら千まで
    # 6なら兆まで
    mattr_accessor(:unit_size) { 6 }

    # 万(4)を超えたら「万」ではなく「一万」とする
    mattr_accessor(:one_number_insert_level) { 4 }

    KANJI_TABLE = "〇一二三四五六七八九"
    UNIT_TABLE  = "十百千万憶兆"

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
      s = str.tr(KANJI_TABLE, "0-9")
      unit_size.times do |i|
        s = s.gsub(/(?<number>\d+)?(?<unit>#{UNIT_TABLE[i]})(?<rest>\d+)?/) do |s| # ブロック引数に md がきてほしい
          md = Regexp.last_match
          v = (md[:number] || 1).to_i * 10**(i+1)
          v + md[:rest].to_i
        end
      end
      s
    end

    # KanjiNumber.number_to_kanji(0)  # => "〇"
    # KanjiNumber.number_to_kanji(1)  # => "一"
    # KanjiNumber.number_to_kanji(10) # => "十"
    # KanjiNumber.number_to_kanji(12) # => "十二"
    # KanjiNumber.number_to_kanji(2)  # => "二"
    # KanjiNumber.number_to_kanji(23) # => "二十三"
    def number_to_kanji(v)
      out = []
      unit_size.step(by: -1, to: 1).each do |x|
        s = UNIT_TABLE[x - 1]
        d = 10**x
        q, r = v.divmod(d)
        case
        when q == 1
          if x >= one_number_insert_level
            out << KANJI_TABLE[q] + s # "万" はおかしいので "一万" とする
          else
            out << s                  # "百" はおかしくないので "一" を入れない
          end
        when q >= 2
          out << KANJI_TABLE[q] + s   # 2以上は "二百" とする
        end
        v = r
      end
      if v == 0 && out.empty?
        out << KANJI_TABLE[v]   # ここをはずせば 0 のとき表示しない。「零」などに変更も可
      elsif v >= 1
        out << KANJI_TABLE[v]
      end
      out.join
    end

    def regexp
      /[#{UNIT_TABLE}#{KANJI_TABLE}]+/o
    end

    def extract(s, &block)
      s.scan(regexp, &block)
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

    KanjiNumber.number_to_kanji(0)                      # => "〇"
    KanjiNumber.number_to_kanji(1)                      # => "一"
    KanjiNumber.number_to_kanji(10)                     # => "十"
    KanjiNumber.number_to_kanji(12)                     # => "十二"
    KanjiNumber.number_to_kanji(2)                      # => "二"
    KanjiNumber.number_to_kanji(23)                     # => "二十三"
    KanjiNumber.number_to_kanji(123)                    # => "百二十三"
    KanjiNumber.number_to_kanji(120)                    # => "百二十"
    KanjiNumber.number_to_kanji(100)                    # => "百"
    KanjiNumber.number_to_kanji(1000)                   # => "千"
    KanjiNumber.number_to_kanji(10000)                  # => "一万"
    KanjiNumber.number_to_kanji(100000)                 # => "一憶"
    KanjiNumber.number_to_kanji(1000000)                # => "一兆"
    KanjiNumber.number_to_kanji(1234.5678)              # => "千二百三十四"

    KanjiNumber.extract("歩百二十三") # => ["百二十三"]
    KanjiNumber.regexp                # => /[十百千万憶兆〇一二三四五六七八九]+/
  end
end
