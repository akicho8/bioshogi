require "spec_helper"

RSpec.describe do
  it "works" do
    info = Bioshogi::Parser.parse(<<~EOT)
    手合割：右香落ち
    上手番

    △７四歩
    まで1手で上手の勝ち
    EOT
    assert { info.to_kif }
  end
end
