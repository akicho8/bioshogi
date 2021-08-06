require_relative "spec_helper"

module Bioshogi
  describe KanjiNumber do
    it "works" do
      assert { KanjiNumber.kanji_to_number_string("") == "" }
      assert { KanjiNumber.kanji_to_number_string("歩") == "歩" }
      assert { KanjiNumber.kanji_to_number_string("歩〇") == "歩0" }
      assert { KanjiNumber.kanji_to_number_string("歩九") == "歩9" }
      assert { KanjiNumber.kanji_to_number_string("歩十") == "歩10" }
      assert { KanjiNumber.kanji_to_number_string("歩十〇") == "歩10" }
      assert { KanjiNumber.kanji_to_number_string("歩十一") == "歩11" }
      assert { KanjiNumber.kanji_to_number_string("歩十九") == "歩19" }
      assert { KanjiNumber.kanji_to_number_string("歩二十") == "歩20" }
      assert { KanjiNumber.kanji_to_number_string("歩二十〇") == "歩20" }
      assert { KanjiNumber.kanji_to_number_string("歩二十一") == "歩21" }
      assert { KanjiNumber.kanji_to_number_string("歩百二十三") == "歩123" }
      assert { KanjiNumber.kanji_to_number_string("歩千二百三十四") == "歩1234" }

      assert { KanjiNumber.kanji_to_number_string("歩十") == "歩10" }
      assert { KanjiNumber.kanji_to_number_string("歩百") == "歩100" }
      assert { KanjiNumber.kanji_to_number_string("歩千") == "歩1000" }
      assert { KanjiNumber.kanji_to_number_string("歩1万") == "歩10000" }
      assert { KanjiNumber.kanji_to_number_string("歩1憶") == "歩100000" }
      assert { KanjiNumber.kanji_to_number_string("歩1兆") == "歩1000000" }

      assert { KanjiNumber.number_to_kanji(0) == "〇" }
      assert { KanjiNumber.number_to_kanji(1) == "一" }
      assert { KanjiNumber.number_to_kanji(10) == "十" }
      assert { KanjiNumber.number_to_kanji(12) == "十二" }
      assert { KanjiNumber.number_to_kanji(2) == "二" }
      assert { KanjiNumber.number_to_kanji(23) == "二十三" }
      assert { KanjiNumber.number_to_kanji(123) == "百二十三" }
      assert { KanjiNumber.number_to_kanji(120) == "百二十" }
      assert { KanjiNumber.number_to_kanji(100) == "百" }
      assert { KanjiNumber.number_to_kanji(1000) == "千" }
      assert { KanjiNumber.number_to_kanji(10000) == "一万" }
      assert { KanjiNumber.number_to_kanji(100000) == "一憶" }
      assert { KanjiNumber.number_to_kanji(1000000) == "一兆" }
      assert { KanjiNumber.number_to_kanji(1234.5678) == "千二百三十四" }

      assert { KanjiNumber.extract("歩百二十三") == ["百二十三"] }
      assert { KanjiNumber.regexp }
    end
  end
end
