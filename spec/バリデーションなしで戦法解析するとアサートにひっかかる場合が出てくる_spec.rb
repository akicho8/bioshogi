require "spec_helper"

RSpec.describe "バリデーションなしで戦法解析するとアサートにひっかかる場合が出てくる" do
  it "駒落ちで、先後を間違えて始まり、飛車移動した場合に想定外の状態になる" do
    info = Bioshogi::Parser.parse(<<~EOT, { validate_feature: false, analysis_feature: true })
P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
P2 * -HI *  *  *  *  *  *  *
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  *
P5 *  *  *  *  *  *  *  *  *
P6 *  *  *  *  *  *  *  *  *
P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
P8 * +KA *  *  *  *  * +HI *
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
-
+7968GI,T0
-8232HI,T0
%TORYO
    EOT
    assert { info.to_kif rescue $!.class == Bioshogi::MustNotHappen }
  end
end
