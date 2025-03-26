require "spec_helper"

RSpec.describe Bioshogi::KanjiNumber do
  it "works" do
    assert { Bioshogi::KanjiNumber.kanji_to_number_string("") == "" }
    assert { Bioshogi::KanjiNumber.kanji_to_number_string("歩") == "歩" }
    assert { Bioshogi::KanjiNumber.kanji_to_number_string("歩〇") == "歩0" }
    assert { Bioshogi::KanjiNumber.kanji_to_number_string("歩九") == "歩9" }
    assert { Bioshogi::KanjiNumber.kanji_to_number_string("歩十") == "歩10" }
    assert { Bioshogi::KanjiNumber.kanji_to_number_string("歩十〇") == "歩10" }
    assert { Bioshogi::KanjiNumber.kanji_to_number_string("歩十一") == "歩11" }
    assert { Bioshogi::KanjiNumber.kanji_to_number_string("歩十九") == "歩19" }
    assert { Bioshogi::KanjiNumber.kanji_to_number_string("歩二十") == "歩20" }
    assert { Bioshogi::KanjiNumber.kanji_to_number_string("歩二十〇") == "歩20" }
    assert { Bioshogi::KanjiNumber.kanji_to_number_string("歩二十一") == "歩21" }
    assert { Bioshogi::KanjiNumber.kanji_to_number_string("歩百二十三") == "歩123" }
    assert { Bioshogi::KanjiNumber.kanji_to_number_string("歩千二百三十四") == "歩1234" }

    assert { Bioshogi::KanjiNumber.kanji_to_number_string("歩十") == "歩10" }
    assert { Bioshogi::KanjiNumber.kanji_to_number_string("歩百") == "歩100" }
    assert { Bioshogi::KanjiNumber.kanji_to_number_string("歩千") == "歩1000" }
    assert { Bioshogi::KanjiNumber.kanji_to_number_string("歩1万") == "歩10000" }
    assert { Bioshogi::KanjiNumber.kanji_to_number_string("歩1憶") == "歩100000" }
    assert { Bioshogi::KanjiNumber.kanji_to_number_string("歩1兆") == "歩1000000" }

    assert { Bioshogi::KanjiNumber.number_to_kanji(0) == "〇" }
    assert { Bioshogi::KanjiNumber.number_to_kanji(1) == "一" }
    assert { Bioshogi::KanjiNumber.number_to_kanji(10) == "十" }
    assert { Bioshogi::KanjiNumber.number_to_kanji(12) == "十二" }
    assert { Bioshogi::KanjiNumber.number_to_kanji(2) == "二" }
    assert { Bioshogi::KanjiNumber.number_to_kanji(23) == "二十三" }
    assert { Bioshogi::KanjiNumber.number_to_kanji(123) == "百二十三" }
    assert { Bioshogi::KanjiNumber.number_to_kanji(120) == "百二十" }
    assert { Bioshogi::KanjiNumber.number_to_kanji(100) == "百" }
    assert { Bioshogi::KanjiNumber.number_to_kanji(1000) == "千" }
    assert { Bioshogi::KanjiNumber.number_to_kanji(10000) == "一万" }
    assert { Bioshogi::KanjiNumber.number_to_kanji(100000) == "一憶" }
    assert { Bioshogi::KanjiNumber.number_to_kanji(1000000) == "一兆" }
    assert { Bioshogi::KanjiNumber.number_to_kanji(1234.5678) == "千二百三十四" }

    assert { Bioshogi::KanjiNumber.extract("歩百二十三") == ["百二十三"] }
    assert { Bioshogi::KanjiNumber.regexp }
  end
end
