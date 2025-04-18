require "spec_helper"

RSpec.describe "日時" do
  it "表記統一" do
    assert { Bioshogi::Parser.parse("開始日時：2000年01月02日(金) 01：02：03").pi.header.to_h == { "開始日時"=>"2000/01/02 01:02:03" } }
    assert { Bioshogi::Parser.parse("開始日時：2000-01-02 01:02:03").pi.header.to_h           == { "開始日時"=>"2000/01/02 01:02:03" } }
  end

  it "「開始日時」も「開始日」も同じ扱い" do
    assert { Bioshogi::Parser.parse("開始日：2000-01-02 01:02:03").pi.header.to_h == { "開始日" => "2000/01/02 01:02:03" } }
  end

  it "時分秒が0なら入れない" do
    assert { Bioshogi::Parser.parse("開始日：2000-01-02 00:00:00").pi.header.to_h == { "開始日" => "2000/01/02" } }
  end

  it "不正な日付" do
    assert { Bioshogi::Parser.parse("開始日：2000-01-99").pi.header.to_h == { "開始日" => "2000-01-99" } }
  end
end
