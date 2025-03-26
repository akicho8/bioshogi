require "spec_helper"

RSpec.describe Bioshogi::Source do
  it "行末の空白だけ削除する" do
    source = Bioshogi::Source.wrap([" a \r", " b \n", " c \r\n "].join)
    assert { source.to_s == [" a", " b", " c"].collect { |e| "#{e}\n" }.join }
  end

  it "一行であっても最後に改行を入れる" do
    assert { Bioshogi::Source.wrap("").to_s == "\n" }
  end

  it "wrap" do
    source = Bioshogi::Source.wrap("")
    assert { source.object_id == Bioshogi::Source.wrap(source).object_id }
  end
end
