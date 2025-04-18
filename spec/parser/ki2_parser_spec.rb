require "spec_helper"

RSpec.describe Bioshogi::Parser::Ki2Parser do
  it "空はKI2と見なさない" do
    assert { !Bioshogi::Parser::Ki2Parser.accept?(nil)  }
    assert { !Bioshogi::Parser::Ki2Parser.accept?("")   }
    assert { !Bioshogi::Parser::Ki2Parser.accept?("\n") }
  end

  it "空白を除いて行の先頭からパースできるものがあればKI2と見なす" do
    assert { Bioshogi::Parser::Ki2Parser.accept?("68S")   }
    assert { Bioshogi::Parser::Ki2Parser.accept?(" 68S")  }
    assert { Bioshogi::Parser::Ki2Parser.accept?("　68S") }
    assert { Bioshogi::Parser::Ki2Parser.accept?("\t68S") }
  end

  it "棋譜部分のパース" do
    assert { Bioshogi::Parser::Ki2Parser.parse("７六歩(77)").pi.move_infos.first[:input] == "７六歩(77)" }
    assert { Bioshogi::Parser::Ki2Parser.parse("７六歩").pi.move_infos.first[:input]     == "７六歩"     }
    assert { Bioshogi::Parser::Ki2Parser.parse("△７六歩").pi.move_infos.first[:input]   == "△７六歩"   }
    assert { Bioshogi::Parser::Ki2Parser.parse("☗７六歩").pi.move_infos.first[:input]    == "☗７六歩"    }
    assert { Bioshogi::Parser::Ki2Parser.parse("☖７六歩").pi.move_infos.first[:input]    == "☖７六歩"    }
  end

  describe "ki2読み込み" do
    before do
      @result = Bioshogi::Parser::Ki2Parser.parse(<<~EOT)
      開始日時：2000/01/01 00:00
      終了日時：2000/01/01 01:00

      *対局前コメント
      ▲７六歩    △３四歩
      *コメント1
      ▲６六歩△８四歩
      *コメント2
      まで4手で後手の勝ち

      変化：1手
      △８四歩
      EOT
    end

    it "ヘッダー部" do
      assert do
        @result.pi.header.to_h == {
          "開始日時" => "2000/01/01",
          "終了日時" => "2000/01/01 01:00:00",
        }
      end
    end

    it "棋譜の羅列" do
      assert do
        @result.pi.move_infos == [
          { input: "▲７六歩" },
          { input: "△３四歩", comments: ["コメント1"] },
          { input: "▲６六歩" },
          { input: "△８四歩", comments: ["コメント2"] },
        ]
      end
    end

    it "対局前コメント" do
      assert { @result.pi.first_comments == ["対局前コメント"] }
    end
  end

  it "千日手" do
    info = Bioshogi::Parser::Ki2Parser.parse(["*引き分け", "まで100手で千日手"].join("\n"))
    info.formatter.container_run_once
    str = info.formatter.last_action_info.judgment_message(info.formatter.container)
    assert { str == nil }
  end
end
# >> .F....F
# >>
# >> Bioshogi::Failures:
# >>
# >>   1) Bioshogi::Parser::Ki2Parser 激指定跡道場4のクリップボード書き出し結果が読める
# >>      Bioshogi::Failure/Bioshogi::Error: parse(Pathname(file).expand_path.read, options)
# >>
# >>      Bioshogi::Errno::ENOENT:
# >>        Bioshogi::No such file or directory @ rb_sysopen - /files/激指定跡道場4のクリップボード書き出し結果.ki2
# >>      # ./lib/bioshogi/parser/base.rb:19:in `read'
# >>      # ./lib/bioshogi/parser/base.rb:19:in `read'
# >>      # ./lib/bioshogi/parser/base.rb:19:in `file_parse'
# >>      # -:14:in `block (2 levels) in <# >>
# >>   2) Bioshogi::Parser::Ki2Parser 読み込み練習
# >>      Bioshogi::Failure/Bioshogi::Error: Bioshogi::Unable to find - to read failed line
# >>
# >>      Bioshogi::Errno::ENOENT:
# >>        Bioshogi::No such file or directory @ rb_sysopen - ../../resources/竜王戦_ki2/龍王戦2002-15 羽生阿部-3.ki2
# >>      # -:117:in `read'
# >>      # -:117:in `read'
# >>      # -:117:in `block (3 levels) in <# >>
# >> Bioshogi::Finished in 0.02764 seconds (files took 1.29 seconds to load)
# >> 7 examples, 2 failures
# >>
# >> Bioshogi::Failed examples:
# >>
# >> rspec -:13 # Bioshogi::Parser::Ki2Parser 激指定跡道場4のクリップボード書き出し結果が読める
# >> rspec -:116 # Bioshogi::Parser::Ki2Parser 読み込み練習
# >>
