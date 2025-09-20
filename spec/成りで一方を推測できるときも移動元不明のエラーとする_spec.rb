require "spec_helper"

RSpec.describe do
  it "works" do
    info = Bioshogi::Parser.parse(<<~EOT)
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・ ・ ・ |
| ・ ・ ・ ・ ・ ・ ・ ・ ・ |
| ・ ・ ・ ・ ・ ・ ・ 銀 ・ |
| ・ ・ ・ ・ ・ ・ ・ ・ ・ |
| ・ ・ ・ ・ ・ ・ ・ ・ 銀 |
| ・ ・ ・ ・ ・ ・ ・ ・ ・ |
| ・ ・ ・ ・ ・ ・ ・ ・ ・ |
| ・ ・ ・ ・ ・ ・ ・ ・ ・ |
| ・ ・ ・ ・ ・ ・ ・ ・ ・ |
+---------------------------+

14銀成
EOT

    expect { info.to_kif }.to raise_error(Bioshogi::AmbiguousFormatError)
  end
end
