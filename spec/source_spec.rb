require "spec_helper"

module Bioshogi
  RSpec.describe Source do
    it "行末の空白だけ削除する" do
      source = Source.wrap([" a \r", " b \n", " c \r\n "].join)
      assert { source.to_s == [" a", " b", " c"].collect { |e| "#{e}\n" }.join }
    end

    it "一行であっても最後に改行を入れる" do
      assert { Source.wrap("").to_s == "\n" }
    end

    it "wrap" do
      source = Source.wrap("")
      assert { source.object_id == Source.wrap(source).object_id }
    end
  end
end
