require "spec_helper"

RSpec.describe Bioshogi::Parser do
  describe "判定" do
    it "KIF" do
      assert { Bioshogi::Parser.parse("手数-指手-消費時間").class == Bioshogi::Parser::KifParser }
      assert { Bioshogi::Parser.parse("1 76歩").class == Bioshogi::Parser::KifParser }
      assert { Bioshogi::Parser.parse("1 投了").class == Bioshogi::Parser::KifParser }
    end
    it "KI2" do
      assert { Bioshogi::Parser.parse("68銀").class == Bioshogi::Parser::Ki2Parser }
      assert { Bioshogi::Parser.parse("☗68銀").class == Bioshogi::Parser::Ki2Parser }
    end
    it "空" do
      assert { Bioshogi::Parser.parse("") rescue $!.class == Bioshogi::FileFormatError }
      assert { Bioshogi::Parser.parse(nil) rescue $!.class == Bioshogi::FileFormatError }
    end
  end

  it "ヘッダー行のセパレータは全角セミコロン" do
    assert { Bioshogi::Parser.parse("a：b").pi.header.to_h == {"a" => "b"} }
    assert { Bioshogi::Parser.parse("a:b：c").pi.header.to_h == {"a:b" => "c"} }
  end

  it "ヘッダー行のセパレータに半角を含めると時間の部分のセミコロンと衝突するので対応しない" do
    assert { Bioshogi::Parser.parse("a:b") rescue $!.class == Bioshogi::FileFormatError }
  end

  it "日時の場合正規化する" do
    assert { Bioshogi::Parser.parse("開始日時：2000-1-1  1:23:45").pi.header.to_h == {"開始日時" => "2000/01/01 01:23:45"} }
    assert { Bioshogi::Parser.parse("終了日時：2000/1/1 01:23:45").pi.header.to_h == {"終了日時" => "2000/01/01 01:23:45"} }
  end
end
# >> Bioshogi::Coverage report generated for Bioshogi::RSpec to /Bioshogi::Users/ikeda/src/bioshogi/coverage. 7 / 15 Bioshogi::LOC (46.67%) covered.
# >> .F..F
# >>
# >> Bioshogi::Failures:
# >>
# >>   1) Bioshogi::Parser ヘッダー行のセパレータに半角を含めると時間の部分のセミコロンと衝突するので対応しない
# >>      Bioshogi::Failure/Bioshogi::Error: raise Bioshogi::FileFormatError, "棋譜のフォーマットが不明です : #{source}"
# >>
# >>      Bioshogi::FileFormatError:
# >>        棋譜のフォーマットが不明です : a:b
# >>      # ./lib/bioshogi/parser.rb:24:in `parse'
# >>      # -:25:in `block (2 levels) in <# >>
# >>   2) Bioshogi::Parser 判定 KI2
# >>      Bioshogi::Failure/Bioshogi::Error: raise Bioshogi::FileFormatError, "棋譜のフォーマットが不明です : #{source}"
# >>
# >>      Bioshogi::FileFormatError:
# >>        棋譜のフォーマットが不明です :
# >>      # ./lib/bioshogi/parser.rb:24:in `parse'
# >>      # -:14:in `block (4 levels) in <# >>      # <internal:prelude>:137:in `__enable'
# >>      # <internal:prelude>:137:in `enable'
# >>      # <internal:prelude>:137:in `__enable'
# >>      # <internal:prelude>:137:in `enable'
# >>      # -:14:in `block (3 levels) in <# >>
# >> Bioshogi::Top 5 slowest examples (0.01695 seconds, 76.3% of total time):
# >>   Bioshogi::Parser ヘッダー行のセパレータは全角セミコロン
# >>     0.01171 seconds -:19
# >>   Bioshogi::Parser 日時の場合正規化する
# >>     0.00216 seconds -:28
# >>   Bioshogi::Parser 判定 KI2
# >>     0.00168 seconds -:11
# >>   Bioshogi::Parser 判定 KIF
# >>     0.00077 seconds -:6
# >>   Bioshogi::Parser ヘッダー行のセパレータに半角を含めると時間の部分のセミコロンと衝突するので対応しない
# >>     0.00064 seconds -:24
# >>
# >> Bioshogi::Finished in 0.02222 seconds (files took 1.48 seconds to load)
# >> 5 examples, 2 failures
# >>
# >> Bioshogi::Failed examples:
# >>
# >> rspec -:24 # Bioshogi::Parser ヘッダー行のセパレータに半角を含めると時間の部分のセミコロンと衝突するので対応しない
# >> rspec -:11 # Bioshogi::Parser 判定 KI2
# >>
