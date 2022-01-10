require "spec_helper"

module Bioshogi
  describe "日時" do
    it "表記統一" do
      assert { Parser.parse("開始日時：2000年01月02日(金) 01：02：03").header.to_h == {"開始日時"=>"2000/01/02 01:02:03"} }
      assert { Parser.parse("開始日時：2000-01-02 01:02:03").header.to_h           == {"開始日時"=>"2000/01/02 01:02:03"} }
    end

    it "日の場合は日時を含まない" do
      assert { Parser.parse("開始日：2000-01-02 01:02:03").header.to_h == {"開始日" => "2000/01/02"} }
    end

    it "不正な日付" do
      assert { Parser.parse("開始日：2000-01-99").header.to_h == {"開始日" => "2000-01-99"} }
    end
  end
end
# >> Coverage report generated for RSpec to /Users/ikeda/src/bioshogi/coverage. 7 / 15 LOC (46.67%) covered.
# >> ...
# >> 
# >> Top 3 slowest examples (0.0429 seconds, 87.6% of total time):
# >>   日時 表記統一
# >>     0.04179 seconds -:5
# >>   日時 日の場合は日時を含まない
# >>     0.0006 seconds -:10
# >>   日時 不正な日付
# >>     0.00052 seconds -:14
# >> 
# >> Finished in 0.04898 seconds (files took 1.6 seconds to load)
# >> 3 examples, 0 failures
# >> 
