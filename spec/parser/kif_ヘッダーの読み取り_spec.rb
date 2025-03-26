require "spec_helper"

RSpec.describe "ヘッダーの読み取り" do
  it "基本" do
    assert { Bioshogi::Parser.parse("key：value").pi.header.to_h == { "key" => "value" } }
  end

  it "要素の上に局面図を含む" do
    assert { Bioshogi::Parser.parse("xxx\nkey：value").pi.header.to_h == { "key" => "value" } }
  end

  it "スペースを含む" do
    assert { Bioshogi::Parser.parse("\t\tkey\t\t：\t\tvalue\t\t").pi.header.to_h == { "key" => "value" } }
    assert { Bioshogi::Parser.parse("　　key　　：　　value　　").pi.header.to_h == { "key" => "value" } }
  end

  it "値がない" do
    assert { Bioshogi::Parser.parse("key：").pi.header.to_h == { } }
  end
end
