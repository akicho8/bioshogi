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
