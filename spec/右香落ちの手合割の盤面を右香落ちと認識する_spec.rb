require "spec_helper"

RSpec.describe do
  it "右香落ちの手合割の盤面を右香落ちと認識することで hirate_like が有効だとわかり「英春流かまいたち戦法」が成立する" do
    info = Bioshogi::Parser.parse(<<~EOT)
手合割：右香落ち
△６二銀 ▲７六歩 △５四歩 ▲５六歩 △５三銀 ▲４八銀 △６四銀 ▲５七銀
EOT
    assert { Bioshogi::Parser.parse(info.to_csa).to_kif.match?(/英春流かまいたち戦法/) }
    assert { Bioshogi::Parser.parse(info.to_kif).to_kif.match?(/英春流かまいたち戦法/) }
    assert { Bioshogi::Parser.parse(info.to_sfen).to_kif.match?(/英春流かまいたち戦法/) }
  end
end
