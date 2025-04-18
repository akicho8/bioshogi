require "spec_helper"

RSpec.describe Bioshogi::Parser::TimeParser do
  it "無効" do
    assert { Bioshogi::Parser::TimeParser.new("").to_time           == nil }
    assert { Bioshogi::Parser::TimeParser.new("9999/99/99").to_time == nil }
  end

  it "基本" do
    assert { Bioshogi::Parser::TimeParser.new("2001/02/03").to_time          == Time.local(2001, 2, 3)          }
    assert { Bioshogi::Parser::TimeParser.new("2001/02/03 04:05:06").to_time == Time.local(2001, 2, 3, 4, 5, 6) }
  end

  it "日本語" do
    assert { Bioshogi::Parser::TimeParser.new("2001年2月3日4時5分6秒").to_time == Time.local(2001, 2, 3, 4, 5, 6) }
  end
end
