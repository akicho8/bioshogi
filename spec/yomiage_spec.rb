require "spec_helper"

module Bioshogi
  RSpec.describe "読み上げ" do
    it "works" do
      info = Parser.parse("position sfen 4k4/9/4G4/9/9/9/9/9/9 b 2G2r2b2g4s4n4l18p 1")
      assert { info.to_yomiage == "gyokugata。ごーいちgyoku。せめかた。ごーさんkin。もちごま。kin。kin" }
      info = Bioshogi::Parser.parse("position sfen 7g1/8k/7pB/9/9/9/9/9/8L b k2rb3g4s4n3l17p 1")
      assert { info.to_yomiage == "gyokugata。にぃいちkin。いちにぃgyoku。にぃさんhu。せめかた。いちさんkaku。いちきゅうkyo。もちごま。なし" }
      info = Bioshogi::Parser.parse("position sfen 7gk/7ns/4G4/9/9/9/9/9/9 b 2r2b2g3s3n4l18p 1")
      assert { info.to_yomiage == "gyokugata。いちいちgyoku。にぃいちkin。いちにぃ銀。にぃにぃkeima。せめかた。ごーさんkin。もちごま。なし" }
    end

    it "ありありのパターン" do
      info = Parser.parse(<<~EOT)
      後手の持駒：金
      +------+
        |v金v玉|
      | 金 金|
      +------+
        先手の持駒：金2銀
      EOT
      if $0 == __FILE__
        tp info.to_yomiage_list
      end
      expected = [
        {:command => "talk", :message => "gyokugata"},
        {:command => "interval", :sleep => 0.5, :sleep_key => :sep1},
        {:command => "talk", :message => "いちいちgyoku"},
        {:command => "interval", :sleep => 1.0, :sleep_key => :sep2},
        {:command => "talk", :message => "にぃいちkin"},
        {:command => "interval", :sleep => 1.0, :sleep_key => :sep2},
        {:command => "talk", :message => "せめかた"},
        {:command => "interval", :sleep => 0.5, :sleep_key => :sep1},
        {:command => "talk", :message => "いちにぃkin"},
        {:command => "interval", :sleep => 1.0, :sleep_key => :sep2},
        {:command => "talk", :message => "にぃにぃkin"},
        {:command => "interval", :sleep => 1.0, :sleep_key => :sep2},
        {:command => "talk", :message => "もちごま"},
        {:command => "interval", :sleep => 0.5, :sleep_key => :sep1},
        {:command => "talk", :message => "kin"},
        {:command => "interval", :sleep => 0.5, :sleep_key => :sep1},
        {:command => "talk", :message => "kin"},
        {:command => "interval", :sleep => 0.5, :sleep_key => :sep1},
        {:command => "talk", :message => "銀"},
      ]
      assert { info.to_yomiage_list == expected }
    end

    it "玉方なし、攻め方なし、持駒なしのパターン" do
      info = Parser.parse("position sfen 9/9/9/9/9/9/9/9/9 b - 1")
      if $0 == __FILE__
        tp info.to_yomiage_list
      end
      expected = [
        {:command => "talk", :message => "gyokugata"},
        {:command => "interval", :sleep => 0.5, :sleep_key => :sep1},
        {:command => "talk", :message => "なし"},
        {:command => "interval", :sleep => 0.5, :sleep_key => :sep1},
        {:command => "talk", :message => "せめかた"},
        {:command => "interval", :sleep => 0.5, :sleep_key => :sep1},
        {:command => "talk", :message => "なし"},
        {:command => "interval", :sleep => 0.5, :sleep_key => :sep1},
        {:command => "talk", :message => "もちごま"},
        {:command => "interval", :sleep => 0.5, :sleep_key => :sep1},
        {:command => "talk", :message => "なし"},
      ]
      assert { info.to_yomiage_list == expected }
    end
  end
end
# >> Coverage report generated for RSpec to /Users/ikeda/src/bioshogi/coverage. 7 / 15 LOC (46.67%) covered.
# >> .|----------+---------------+-------+-----------|
# >> | command  | message       | sleep | sleep_key |
# >> |----------+---------------+-------+-----------|
# >> | talk     | gyokugata     |       |           |
# >> | interval |               |   0.5 | sep1      |
# >> | talk     | いちいちgyoku |       |           |
# >> | interval |               |   1.0 | sep2      |
# >> | talk     | にぃいちkin   |       |           |
# >> | interval |               |   1.0 | sep2      |
# >> | talk     | せめかた      |       |           |
# >> | interval |               |   0.5 | sep1      |
# >> | talk     | いちにぃkin   |       |           |
# >> | interval |               |   1.0 | sep2      |
# >> | talk     | にぃにぃkin   |       |           |
# >> | interval |               |   1.0 | sep2      |
# >> | talk     | もちごま      |       |           |
# >> | interval |               |   0.5 | sep1      |
# >> | talk     | kin           |       |           |
# >> | interval |               |   0.5 | sep1      |
# >> | talk     | kin           |       |           |
# >> | interval |               |   0.5 | sep1      |
# >> | talk     | 銀            |       |           |
# >> |----------+---------------+-------+-----------|
# >> .|----------+-----------+-------+-----------|
# >> | command  | message   | sleep | sleep_key |
# >> |----------+-----------+-------+-----------|
# >> | talk     | gyokugata |       |           |
# >> | interval |           |   0.5 | sep1      |
# >> | talk     | なし      |       |           |
# >> | interval |           |   0.5 | sep1      |
# >> | talk     | せめかた  |       |           |
# >> | interval |           |   0.5 | sep1      |
# >> | talk     | なし      |       |           |
# >> | interval |           |   0.5 | sep1      |
# >> | talk     | もちごま  |       |           |
# >> | interval |           |   0.5 | sep1      |
# >> | talk     | なし      |       |           |
# >> |----------+-----------+-------+-----------|
# >> .
# >> 
# >> Top 3 slowest examples (0.03036 seconds, 83.7% of total time):
# >>   読み上げ works
# >>     0.02167 seconds -:5
# >>   読み上げ ありありのパターン
# >>     0.00668 seconds -:14
# >>   読み上げ 玉方なし、攻め方なし、持駒なしのパターン
# >>     0.002 seconds -:50
# >> 
# >> Finished in 0.03627 seconds (files took 1.65 seconds to load)
# >> 3 examples, 0 failures
# >> 
