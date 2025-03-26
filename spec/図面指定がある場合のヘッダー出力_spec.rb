require "spec_helper"

RSpec.describe "図面指定がある場合のヘッダー出力" do
  it "平手" do
    container = Bioshogi::Container::Basic.new
    container.board.placement_from_preset("裸玉")
    container.execute("58玉")
    container.execute("52玉")

    container.turn_info.handicap = false
    info = Bioshogi::Parser.parse("position #{container.to_short_sfen}")
    expect(info.to_ki2).to eq(<<~EOT)
    後手の持駒：なし
      ９ ８ ７ ６ ５ ４ ３ ２ １
    +---------------------------+
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|一
    | ・ ・ ・ ・v玉 ・ ・ ・ ・|二
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|三
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
    | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
    | ・ 角 ・ ・ 玉 ・ ・ 飛 ・|八
    | 香 桂 銀 金 ・ 金 銀 桂 香|九
    +---------------------------+
    先手の持駒：なし
    先手番

    まで0手で後手の勝ち
    EOT
  end

  it "駒落ち" do
    container = Bioshogi::Container::Basic.new
    container.board.placement_from_preset("裸玉")
    container.execute("58玉")
    container.execute("52玉")

    container.turn_info.handicap = true
    info = Bioshogi::Parser.parse("position #{container.to_short_sfen}")
    expect(info.to_ki2).to eq(<<~EOT)
    上手の持駒：なし
      ９ ８ ７ ６ ５ ４ ３ ２ １
    +---------------------------+
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|一
    | ・ ・ ・ ・v玉 ・ ・ ・ ・|二
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|三
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
    | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
    | ・ 角 ・ ・ 玉 ・ ・ 飛 ・|八
    | 香 桂 銀 金 ・ 金 銀 桂 香|九
    +---------------------------+
    下手の持駒：なし
    上手番

    まで0手で下手の勝ち
    EOT
  end
end
